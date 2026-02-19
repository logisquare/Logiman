using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class OrderDispatchModel
    {
        public int    CenterCode                { get; set; }
        public long   OrderNo                   { get; set; }
        public long   AddSeqNo                  { get; set; }
        public long   GoodsSeqNo                { get; set; }
        public long   DispatchSeqNo             { get; set; }
        public string DispatchSeqNos            { get; set; }
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
        public string FromYMD                   { get; set; }
        public string ToYMD                     { get; set; }
        public string AdminID                   { get; set; }
        public string AdminName                 { get; set; }
        public string AdminTelNo                { get; set; }
        public string AdminMobileNo             { get; set; }
        public int    TotalCnt                  { get; set; }
        public int    SuccCnt                   { get; set; }
        public int    FailCnt                   { get; set; }
        public string OrderNos                  { get; set; }
        public int    DispatchType              { get; set; }
        public int    QuickType                 { get; set; }
        public int    ContractCenterCode        { get; set; }
        public string GoodsSeqNos               { get; set; }
        public int    ClientCode                { get; set; }
        public int    ChargeSeqNo               { get; set; }
        public string ArrivalReportNo           { get; set; }
        public string CnlFlag                   { get; set; }
        public string ContractInfo              { get; set; }
        public int    ListType                  { get; set; }
        public int    DateType                  { get; set; }
        public string DateFrom                  { get; set; }
        public string DateTo                    { get; set; }
        public string OrderLocationCodes        { get; set; }
        public string OrderItemCodes            { get; set; }
        public string ComName                   { get; set; }
        public string CarNo                     { get; set; }
        public string DispatchAdminName         { get; set; }
        public string AccessCenterCode          { get; set; }
        public long   NetworkNo                 { get; set; }
        public double PurchaseOrgAmt            { get; set; }
        public int    ProcType                  { get; set; }
        public string DispatchInfo              { get; set; }
        public string PurchaseSeqNos            { get; set; }
        public double SupplyAmt                 { get; set; }
        public double TaxAmt                    { get; set; }
        public int    PurchaseType              { get; set; }
        public double PurchaseSupplyAmt         { get; set; }
        public int    InsureExceptKind          { get; set; } = 1;

    }


    public class OrderDispatchGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string TransInfo                 { get; set; }
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
        public string PayClientTypeM            { get; set; }
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
        public string CarTypeCode               { get; set; }
        public string CarTonCodeM               { get; set; }
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
        public int    GoodsDispatchType         { get; set; }
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
        public string BLNo                      { get; set; }
        public string CntrNo                    { get; set; }
        public string SealNo                    { get; set; }
        public string DONo                      { get; set; }
        public string StockNo                   { get; set; }
        public string GoodsNote                 { get; set; }
        public string GMOrderType               { get; set; }
        public string GMTripID                  { get; set; }
        public string TaxClientName             { get; set; }
        public string TaxClientCorpNo           { get; set; }
        public string TaxClientChargeName       { get; set; }
        public string TaxClientChargeTelNo      { get; set; }
        public string TaxClientChargeEmail      { get; set; }
        public string TransRateInfo             { get; set; }
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
        public long   SaleTaxAmt                { get; set; }
        public long   PurchaseSupplyAmt         { get; set; }
        public string PurchaseTaxAmt            { get; set; }
        public long   AdvanceSupplyAmt3         { get; set; }
        public long   AdvanceSupplyAmt4         { get; set; }
        public string DispatchSupplyAmt         { get; set; }
        public string DispatchTaxAmt            { get; set; }
        public int    FileCnt                   { get; set; }
        public int    OrderStatus               { get; set; }
        public string OrderStatusM              { get; set; }
        public string GoodsDispatchTypeM        { get; set; }
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
        public string AcceptTeamCodeM           { get; set; }
        public string CnlFlag                   { get; set; }
        public string CnlDate                   { get; set; }
        public string CnlAdminID                { get; set; }
        public string CnlAdminName              { get; set; }
        public string CnlReason                 { get; set; }
        public string CenterNameInfo            { get; set; }
        public string CorpNoInfo                { get; set; }
        public string CeoNameInfo               { get; set; }
        public string BizTypeInfo               { get; set; }
        public string BizClassInfo              { get; set; }
        public string TelNoInfo                 { get; set; }
        public string FaxNoInfo                 { get; set; }
        public string EmailInfo                 { get; set; }
        public string AddrPostInfo              { get; set; }
        public string AddrInfo                  { get; set; }
        public string BankNameInfo              { get; set; }
        public string EncAcctNoInfo             { get; set; }
        public string AcctNameInfo              { get; set; }
        public int    ClientCode                { get; set; }
        public string ClientName                { get; set; }
        public string ClientFaxNo               { get; set; }
        public double PurchaseSupplyAmtTotal    { get; set; }
        public double PurchaseTaxAmtTotal       { get; set; }
        public double TransPurchaseSupplyAmt    { get; set; }
        public double EtcPurchaseSupplyAmt      { get; set; }
        public double TransPurchaseTaxAmt       { get; set; }
        public double EtcPurchaseTaxAmt         { get; set; }
        public string ComName                   { get; set; }
        public string CarNo                     { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string ItemCode                  { get; set; }
        public string ItemCodeM                 { get; set; }
        public string ClientTaxKind             { get; set; }
        public string PurchaseSeqNo             { get; set; }
        public string TotCBM                    { get; set; }
        public string TotVolume                 { get; set; }
        public string TotWeight                 { get; set; }
        public string NetworkNo                 { get; set; }
        public string CargopassOrderNo          { get; set; }
        public string CargopassFlag             { get; set; }
        public string CargopassInfo             { get; set; }
        public string SupplyAmt                 { get; set; }
        public string OrgAmt                    { get; set; }
        public string DispatchCarNo             { get; set; }
        public long   ArrivalReportClientCode   { get; set; }
        public string ArrivalReportClientName   { get; set; }
        public string ArrivalReportChargeName   { get; set; }
        public string ArrivalReportChargeCell   { get; set; }
        public string ArrivalReportNo           { get; set; }
        public string GoodsArrivalReportFlag    { get; set; }
        public string ArrivalDocumentFlag       { get; set; }
        public string DispatchInfo              { get; set; }
        public string ContractInfo              { get; set; }
        public string ContractTypeM             { get; set; }
        public string ContractStatusM           { get; set; }
        public string ContractStatusMView       { get; set; }
        public string ClientCorpNo              { get; set; }
        public string SaleAmt                   { get; set; }
        public string DispatchCnt               { get; set; }
        public string ComCorpNo                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string TaxAmt                    { get; set; }
        public string AdvanceOrgAmt             { get; set; }
        public string ShippingCompany           { get; set; }
        public string ShippingShipName          { get; set; }
        public string PickupCY                  { get; set; }
        public string GetCY                     { get; set; }
        public string AcctNo                    { get; set; }
        public string SaleClosingFlag           { get; set; }
        public string SaleClosingKind           { get; set; }
        public string PurchaseClosingFlag       { get; set; }
        public string DeliveryLocationCodeM     { get; set; }
        public string DeliveryLocationCode      { get; set; }
        public string DispatchTypeM             { get; set; }
        public int    ContractType              { get; set; }
        public int    ContractStatus            { get; set; }
        public int    TransType                 { get; set; }
        public int    JContractType             { get; set; }
        public string JContractTypeM            { get; set; }
        public string JContractStatus           { get; set; }
        public string JContractStatusM          { get; set; }
        public string JContractStatusMView      { get; set; }
        public string JContractInfo             { get; set; }
        public string JCargopassOrderNo         { get; set; }
        public string JCargopassFlag            { get; set; }
        public string JCargopassInfo            { get; set; }
        public string JNetworkNo                { get; set; }
        public int    GContractType             { get; set; }
        public string GContractTypeM            { get; set; }
        public string GContractStatus           { get; set; }
        public string GContractStatusM          { get; set; }
        public string GContractStatusMView      { get; set; }
        public string GContractInfo             { get; set; }
        public string GCargopassOrderNo         { get; set; }
        public string GCargopassFlag            { get; set; }
        public string GCargopassInfo            { get; set; }
        public string GNetworkNo                { get; set; }
        public string PickupStandard            { get; set; }
        public string TransPickupYMD            { get; set; }
        public string ContractPickupYMD         { get; set; }
        public string QuickPaySupplyFee         { get; set; }
        public string QuickPayTaxFee            { get; set; }
        public int    CarDivType1               { get; set; }
        public string CarDivTypeM1              { get; set; }	
        public string DriverName1               { get; set; }	
        public string DriverCell1               { get; set; }	
        public string ComName1                  { get; set; }	
        public string ComCorpNo1                { get; set; }	
        public int    CarDivType2               { get; set; }	
        public string CarDivTypeM2              { get; set; }	
        public string DriverName2               { get; set; }	
        public string DriverCell2               { get; set; }	
        public string ComName2                  { get; set; }	
        public string ComCorpNo2                { get; set; }	
        public int    CarDivType3               { get; set; }	
        public string CarDivTypeM3              { get; set; }	
        public string DriverName3               { get; set; }	
        public string DriverCell3               { get; set; }	
        public string ComName3                  { get; set; }	
        public string ComCorpNo3                { get; set; }	
        public int    CarDivType4               { get; set; }	
        public string CarDivTypeM4              { get; set; }	
        public string DriverName4               { get; set; }	
        public string DriverCell4               { get; set; }	
        public string ComName4                  { get; set; }	
        public string ComCorpNo4                { get; set; }	
        public int    PayType                   { get; set; }	
        public double AdvanceSupplyAmt          { get; set; }	
        public string AdvanceItemCodeM          { get; set; }	
        public string AdvanceItemCode           { get; set; }	
        public string AcceptTelNo               { get; set; }	
        public string ComTaxKind                { get; set; }
    }

    public class ReqOrderDispatchList
    {
        public long   OrderNo                 { get; set; }
        public string OrderNos                { get; set; }
        public string OrderNos1               { get; set; }
        public string OrderNos2               { get; set; }
        public long   SaleClosingSeqNo        { get; set; }
        public int    CenterCode              { get; set; }
        public long   ClientCode              { get; set; }
        public string ClientCodes             { get; set; }
        public int    TransCenterCode         { get; set; }
        public int    ContractCenterCode      { get; set; }
        public int    ListType                { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public int    GoodsDispatchType       { get; set; }  
        public int    DispatchType            { get; set; }  
        public string OrderLocationCodes      { get; set; }
        public string DeliveryLocationCodes   { get; set; }
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
        public string CarNo2                  { get; set; }
        public string CarNo3                  { get; set; }
        public string DriverName              { get; set; }
        public string GoodsName               { get; set; }
        public string AcceptAdminName         { get; set; }
        public string CsAdminID               { get; set; }
        public string MyChargeFlag            { get; set; }
        public string MyOrderFlag             { get; set; }
        public string CnlFlag                 { get; set; }
        public string OrderFPISFlag           { get; set; }
        public string DispatchAdminName       { get; set; }
        public string ArrivalReportFlag       { get; set; }
        public int    ArrivalReportClientCode { get; set; }
        public string ArrivalReportClientName { get; set; }
        public string PurchaseItemCode        { get; set; }
        public string orderFPISFlag           { get; set; }
        public int    GetStandardType         { get; set; }
        public string AdminID                 { get; set; }
        public string AccessCenterCode        { get; set; }
        public int    OrderByPageType         { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class ResOrderDispatchList
    {
        public List<OrderDispatchGridModel> list { get; set; }
        public int    RecordCnt         { get; set; }
        public double OrgAmtTotal       { get; set; }
        public double SupplyAmtTotal    { get; set; }
        public double TaxAmtTotal       { get; set; }
    }

    public class ReqOrderDispatchUpd
    {
        public int CenterCode               { get; set; }
        public int ContractCenterCode       { get; set; }
        public int ReqSeqNo                 { get; set; }
        public int NetworkNo                { get; set; }
        public string OrderNos              { get; set; }
        public int GradeCode                { get; set; }
        public int GoodsDispatchType        { get; set; }
        public string OrderItemCode         { get; set; }
        public string OrderLocationCode     { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public string FromYMD               { get; set; }
        public string ToYMD                 { get; set; }
        public double PurchaseOrgAmt        { get; set; }
        public int ProcType                 { get; set; }
        public int DispatchType             { get; set; }
        public string AccessCenterCode      { get; set; }
        public string AdminID               { get; set; }
        public string AdminName             { get; set; }

    }

    public class ResOrderDispatchUpd
    {
        public int TotalCnt { get; set; }
        public int CancelCnt { get; set; }
    }

    //비용
    public class OrderDispatchPayModel
    {
        public long   SeqNo         { get; set; }
        public int    CenterCode    { get; set; }
        public long   OrderNo       { get; set; }
        public long   GoodsSeqNo    { get; set; }
        public long   DispatchSeqNo { get; set; }
        public int    PayType       { get; set; }
        public int    TaxKind       { get; set; }
        public string ItemCode      { get; set; }
        public long   ClientCode    { get; set; }
        public string ClientName    { get; set; }
        public long   RefSeqNo      { get; set; }
        public int    CarDivType    { get; set; }
        public long   ComCode       { get; set; }
        public long   CarSeqNo      { get; set; }
        public long   DriverSeqNo   { get; set; }
        public double SupplyAmt     { get; set; }
        public double TaxAmt        { get; set; }
        public string RegAdminID    { get; set; }
        public string RegAdminName  { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdAdminName  { get; set; }
    }

    public class OrderDispatchPayGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
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
        public string PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string PayClientChargeName       { get; set; }
        public string PayClientChargePosition   { get; set; }
        public string PayClientChargeTelExtNo   { get; set; }
        public string PayClientChargeTelNo      { get; set; }
        public string PayClientChargeCell       { get; set; }
        public string PayClientChargeLocation   { get; set; }
        public string ConsignorCode             { get; set; }
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
        public string AcceptAdminName           { get; set; }
        public string AcceptDate                { get; set; }
        public string UpdAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string OrderStatus               { get; set; }
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
        public string OrderStatusM              { get; set; }
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string DispatchSeqNo             { get; set; }
        public string ComName                   { get; set; }
        public string ComCorpNo                 { get; set; }
        public string CarNo                     { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string GoodsSeqNo                { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public double CBM                       { get; set; }
        public string Quantity                  { get; set; }
        public string GoodsNote                 { get; set; }
        public string PurchaseSeqNo             { get; set; }
        public string ItemCodeM                 { get; set; }
        public double PurchaseOrgAmt            { get; set; }
        public double PurchaseSupplyAmt         { get; set; }
        public double PurchaseTaxAmt            { get; set; }
        public double SaleSupplyAmt             { get; set; }
        public int    ComTaxKind                { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTonCodeM               { get; set; }
        public string CarTypeCode               { get; set; }
        public string CarTypeCodeM              { get; set; }
        public string TransRateInfo             { get; set; }
        public string ApplySeqNo                { get; set; }
        public string TransDtlSeqNo             { get; set; }
        public int    TransRateStatus           { get; set; }
        public string CarDivType                { get; set; }
        public string CarDivTypeM               { get; set; }
        public string TransRateChk              { get; set; }
        public string ClosingFlag               { get; set; }
        public int    BillStatus                { get; set; }
        public int    SendStatus                { get; set; }
        public int    TaxKind                   { get; set; }
    }

    public class ResOrderDispatchPayList
    {
        public List<OrderDispatchPayGridModel> list      { get; set; }
        public int                             RecordCnt { get; set; }
    }

    public class OrderDispatchPayItemModel
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

    public class ReqOrderDispatchPayItemList
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

    public class ResOrderDispatchPayItemList
    {
        public List<OrderDispatchPayItemModel> list { get; set; }
        public int RecordCnt { get; set; }
    }


    public class OrderDispatchFileModel
    {
        public long   FileSeqNo   { get; set; }
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
    public class ReqDispatchOrderFileList
    {
        public long FileSeqNo { get; set; }
        public long OrderNo { get; set; }
        public long DispatchSeqNo { get; set; }
        public int FileRegType { get; set; }
        public int FileType { get; set; }
        public int FileGubun { get; set; }
        public int CenterCode { get; set; }
        public string DelFlag { get; set; }
        public string AccessCenterCode { get; set; }
        public int PageSize { get; set; }
        public int PageNo { get; set; }
    }
    public class ResDispatchOrderFileList
    {
        public List<OrderDispatchFileGridModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class OrderDispatchFileGridModel
    {
        public string FileSeqNo      { get; set; }
        public string EncFileSeqNo   { get; set; }
        public int    CenterCode     { get; set; }
        public string OrderNo        { get; set; }
        public int    FileRegType    { get; set; }
        public string FileRegTypeM   { get; set; }
        public string FileName       { get; set; }
        public int    FileType       { get; set; }
        public string FileTypeM      { get; set; }
        public int    FileGubun      { get; set; }
        public string FileNameNew    { get; set; }
        public string EncFileNameNew { get; set; }
        public string FileDir        { get; set; }
        public string TempFlag       { get; set; }
        public string DelFlag        { get; set; }
        public string FilePGGubun    { get; set; }
        public string FilePGGubunM   { get; set; }
        public string RegAdminID     { get; set; }
        public string RegDate        { get; set; }
        public string UpdAdminID     { get; set; }
        public string UpdDate        { get; set; }
        public string PickupYMD      { get; set; }
        public string ConsignorName  { get; set; }
    }

    public class ResOrderDispatchAdvanceList
    {
        public List<OrderDispatchAdvanceGridModel> list { get; set; }
        public int RecordCnt { get; set; }
        public int TotalAmt { get; set; }
    }

    public class OrderDispatchAdvanceGridModel { 
        public string OrderNo   { get; set; }
        public int    PayType   { get; set; }
        public string ItemCodeM { get; set; }
        public double OrgAmt    { get; set; }
        public double SupplyAmt { get; set; }
        public double TaxAmt    { get; set; }
    }

    public class ReqDailySafetyCheckList
    {

        public int    CenterCode       { get; set; }
        public int    DateType         { get; set; }
        public string DateYMD          { get; set; }
        public string ComName          { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarNo            { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string ReplyFlag        { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class DailySafetyCheckListModel
    {
        public string DispatchSeqNo      { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public int    DispatchType       { get; set; }
        public string DispatchTypeM      { get; set; }
        public string RefSeqNo           { get; set; }
        public string ComCode            { get; set; }
        public string ComName            { get; set; }
        public string ComCorpNo          { get; set; }
        public string CarNo              { get; set; }
        public string DriverName         { get; set; }
        public string DriverCell         { get; set; }
        public int    DispatchStatus     { get; set; }
        public string DispatchStatusM    { get; set; }
        public string SeqNo              { get; set; }
        public string Reply1             { get; set; }
        public string Reply2             { get; set; }
        public string Reply3             { get; set; }
        public string Reply4             { get; set; }
        public string Reply5             { get; set; }
        public string Reply6             { get; set; }
        public string ReplyFlag          { get; set; }
        public string ReplyDate          { get; set; }
        public int    SendCnt            { get; set; }
        public string SendYMD            { get; set; }
        public string SendDate           { get; set; }
        public string RegYMD             { get; set; }
        public string OrderNo            { get; set; }
        public string PickupYMD          { get; set; }
        public string OrderItemCode      { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderLocationCode  { get; set; }
        public string OrderLocationCodeM { get; set; }
        public string CargoManFlag       { get; set; }
    }

    public class ResDailySafetyCheckList
    {
        public List<DailySafetyCheckListModel> list      { get; set; }
        public int                             RecordCnt { get; set; }
    }

    public class DailySafetyCheckInsModel
    {
        public long   SeqNo         { get; set; }
        public int    CenterCode    { get; set; }
        public long   OrderNo       { get; set; }
        public long   DispatchSeqNo { get; set; }
        public long   RefSeqNo      { get; set; }
        public string AdminID       { get; set; }
        public string AdminName     { get; set; }
    }

    public class PrintHistoryModel
    {
        public int    CenterCode       { get; set; }
        public string OrderNos         { get; set; }
        public string OrderNos1        { get; set; }
        public string OrderNos2        { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string RecName          { get; set; }
        public string RecMail          { get; set; }
        public string SendName         { get; set; }
        public string SendMail         { get; set; }
        public string ClosingFlag      { get; set; }
    }

    public class ReqPrintHistory
    {
        public int    CenterCode       { get; set; }
        public int    SeqNo            { get; set; }
        public long   OrderNo          { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string RecName          { get; set; }
        public string SendName         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResPrintHistory
    {
        public List<ResPrintHistoryListModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class ResPrintHistoryListModel
    {
        public int    SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public string PayClientName    { get; set; }
        public string OrderNo          { get; set; }
        public string SaleClosingSeqNo { get; set; }
        public int    PayClientCode    { get; set; }
        public string RecName          { get; set; }
        public string RecMail          { get; set; }
        public string SendName         { get; set; }
        public string SendMail         { get; set; }
        public double SupplyAmt        { get; set; }
        public double TaxAmt           { get; set; }
        public string ClosingFlag      { get; set; }
        public string ClosingAdminName { get; set; }
        public string ClosingDate      { get; set; }
        public string SendYMD          { get; set; }
        public string SendDate         { get; set; }
    }

    public class ReqOrderDispatchArrivalWorkList
    {
        public int    CenterCode              { get; set; }
        public int    ListType                { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public string ArrivalReportClientName { get; set; }
        public string AccessCenterCode        { get; set; }
    }

    public class OrderDispatchArrivalWorkModel
    {

        public int    RowNum                  { get; set; }
        public int    CenterCode              { get; set; }
        public string CenterName              { get; set; }
        public string ArrivalReportClientCode { get; set; }
        public string ArrivalReportClientName { get; set; }
        public string ArrivalReportChargeName { get; set; }
        public string ArrivalReportChargeCell { get; set; }
    }

    public class ResOrderDispatchArrivalWorkList
    {
        public List<OrderDispatchArrivalWorkModel> list      { get; set; }
        public int                                 RecordCnt { get; set; }

    }

    public class ReqOrderDispatchArrivalWorkExcelList
    {
        public int    CenterCode              { get; set; }
        public int    ListType                { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public long   ArrivalReportClientCode { get; set; }
        public string ArrivalReportChargeName { get; set; }
        public string AccessCenterCode        { get; set; }
    }

    public class OrderDispatchArrivalWorkExcelModel
    {
        public int    CenterCode              { get; set; }
        public string CenterName              { get; set; }
        public string OrderNo                 { get; set; }
        public string ArrivalReportFlag       { get; set; }
        public string DocumentFlag            { get; set; }
        public string QuickGetFlag            { get; set; }
        public string ConsignorName           { get; set; }
        public string PickupYMD               { get; set; }
        public string GetYMD                  { get; set; }
        public string GetPlace                { get; set; }
        public string GetPlaceChargeName      { get; set; }
        public int    Volume                  { get; set; }
        public double CBM                     { get; set; }
        public double Weight                  { get; set; }
        public string Nation                  { get; set; }
        public string BookingNo               { get; set; }
        public string ArrivalReportClientName { get; set; }
        public string ArrivalReportChargeName { get; set; }
        public string ArrivalReportChargeCell { get; set; }
        public int    DispatchType            { get; set; }
        public string DispatchTypeM           { get; set; }
        public string CarNo                   { get; set; }
        public string DriverName              { get; set; }
        public string DriverCell              { get; set; }
    }

    public class ResOrderDispatchArrivalWorkExcelList
    {
        public List<OrderDispatchArrivalWorkExcelModel> list      { get; set; }
        public int                                      RecordCnt { get; set; }

    }

    public class ReqOrderDispatchCount
    {
        public string AccessCenterCode     { get; set; }
        public string AdminID              { get; set; }
    }

    public class ResOrderDispatchCount
    {
        public int NetworkDispatchCnt      { get; set; }
        public int NetworkDispatchType1Cnt { get; set; }
        public int NetworkDispatchType2Cnt { get; set; }
        public int NetworkDispatchType3Cnt { get; set; }
        public int AmtRequestCnt           { get; set; }
    }
}