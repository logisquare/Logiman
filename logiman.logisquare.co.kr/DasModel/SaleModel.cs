using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class SaleClientGridModel
    {
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string PayClientCode         { get; set; }
        public string PayClientName         { get; set; }
        public string PayClientCorpNo       { get; set; }
        public int    ClientStatus          { get; set; }
        public string ClientStatusM         { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientTaxKind         { get; set; }
        public string ClientTaxKindM        { get; set; }
        public string ClientPayDay          { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public double SaleOrgAmt            { get; set; }
        public double SaleSupplyAmt         { get; set; }
        public double SaleTaxAmt            { get; set; }
        public int    OrderCnt              { get; set; }
        public int    ClosingOrderCnt       { get; set; }
        public int    CarryoverCnt          { get; set; }
        public string CsAdminNames          { get; set; }
    }

    public class SaleClientOrderGridModel
    {
        public int    SeqNo                   { get; set; }
        public int    Sort                    { get; set; }
        public string OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public string CenterName              { get; set; }
        public string OrderItemCode           { get; set; }
        public string OrderItemCodeM          { get; set; }
        public string OrderLocationCode       { get; set; }
        public string OrderLocationCodeM      { get; set; }
        public string OrderClientCode         { get; set; }
        public string OrderClientName         { get; set; }
        public string PayClientCode           { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorCode           { get; set; }
        public string ConsignorName           { get; set; }
        public string PickupYMD               { get; set; }
        public string PickupPlace             { get; set; }
        public string GetYMD                  { get; set; }
        public string GetPlace                { get; set; }
        public string SaleCarryoverFlag       { get; set; }
        public double SaleOrgAmt              { get; set; }
        public double SaleSupplyAmt           { get; set; }
        public double SaleTaxAmt              { get; set; }
        public string SaleClosingSeqNo        { get; set; }
        public string ClosingFlag             { get; set; }
        public string ClosingKind             { get; set; }
        public string ClosingKindM            { get; set; }
        public string ClosingAdminName        { get; set; }
        public string ClosingDate             { get; set; }
        public double CBM                     { get; set; }
        public int    Volume                  { get; set; }
        public double Weight                  { get; set; }
        public string Hawb                    { get; set; }
        public string Mawb                    { get; set; }
        public string Nation                  { get; set; }
        public string CarNo                   { get; set; }
        public double AdvanceSupplyAmt3       { get; set; }
        public double AdvanceSupplyAmt4       { get; set; }
        public int    BillStatus              { get; set; }
        public string BillStatusM             { get; set; }
        public string DeliveryLocationCode    { get; set; }
        public string DeliveryLocationCodeM   { get; set; }
    }

    public class ReqSaleClientList
    {
        public int    CenterCode              { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string DeliveryLocationCodes   { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderClientName         { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName           { get; set; }
        public string Hawb                    { get; set; }
        public string ClosingFlag             { get; set; }
        public string CarryOverFlag           { get; set; }
        public string CsAdminID               { get; set; }
        public string AccessCenterCode        { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class ResSaleClientList
    {
        public List<SaleClientGridModel> list      { get; set; }
        public int                       RecordCnt { get; set; }
    }
    
    public class ReqSaleClientOrderList
    {
        public int    CenterCode              { get; set; }
        public long   PayClientCode           { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string DeliveryLocationCodes   { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderClientName         { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName           { get; set; }
        public string Hawb                    { get; set; }
        public string ClosingFlag             { get; set; }
        public string CarryOverFlag           { get; set; }
        public string AccessCenterCode        { get; set; }
    }

    public class ResSaleClientOrderList
    {
        public List<SaleClientOrderGridModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class ReqSaleCarryoverUpd
    {
        public int    CenterCode   { get; set; }
        public string OrderNos1    { get; set; }
        public string OrderNos2    { get; set; }
        public string OrderNos3    { get; set; }
        public string OrderNos4    { get; set; }
        public string OrderNos5    { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdAdminName { get; set; }
    }

    public class ResSaleCarryoverUpd
    {
        public int TotalCnt   { get; set; }
        public int SuccessCnt { get; set; }
    }


    public class ReqSaleCarryoverDel
    {
        public int    CenterCode   { get; set; }
        public string OrderNos1    { get; set; }
        public string OrderNos2    { get; set; }
        public string OrderNos3    { get; set; }
        public string OrderNos4    { get; set; }
        public string OrderNos5    { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }
    }

    public class ResSaleCarryoverDel
    {
        public int TotalCnt   { get; set; }
        public int SuccessCnt { get; set; }
    }

    public class ReqSaleClosingIns
    {
        public int    CenterCode       { get; set; }
        public string OrderNos1        { get; set; }
        public string OrderNos2        { get; set; }
        public string OrderNos3        { get; set; }
        public string OrderNos4        { get; set; }
        public string OrderNos5        { get; set; }
        public double SaleOrgAmt       { get; set; }
        public int    ClosingKind      { get; set; }
        public string ClosingAdminID   { get; set; }
        public string ClosingAdminName { get; set; }
    }

    public class ResSaleClosingIns
    {
        public long   SaleClosingSeqNo { get; set; }
        public double SaleOrgAmt       { get; set; }
    }

    public class ReqSaleClosingCnl
    {
        public int    CenterCode        { get; set; }
        public string SaleClosingSeqNos { get; set; }
        public string CnlAdminID        { get; set; }
        public string CnlAdminName      { get; set; }
    }
    
    public class SaleClosingGridModel
    {
        public string SaleClosingSeqNo      { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string CeoName               { get; set; }
        public string CorpNo                { get; set; }
        public string BizType               { get; set; }
        public string BizClass              { get; set; }
        public string TelNo                 { get; set; }
        public string Addr                  { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public string ClientCorpNo          { get; set; }
        public string ClientCeoName         { get; set; }
        public string ClientBizType         { get; set; }
        public string ClientBizClass        { get; set; }
        public string ClientTelNo           { get; set; }
        public string ClientAddr            { get; set; }
        public int    ClientStatus          { get; set; }
        public string ClientStatusM         { get; set; }
        public string ClientCloseYMD        { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientTaxKind         { get; set; }
        public string ClientTaxKindM        { get; set; }
        public string ClientPayDay          { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public double OrgAmt                { get; set; }
        public double SupplyAmt             { get; set; }
        public double TaxAmt                { get; set; }
        public int    BillStatus            { get; set; }
        public string BillStatusM           { get; set; }
        public int    BillKind              { get; set; }
        public string BillKindM             { get; set; }
        public string BillChargeName        { get; set; }
        public string BillChargeTelNo       { get; set; }
        public string BillChargeEmail       { get; set; }
        public string BillWrite             { get; set; }
        public string BillWriteYM           { get; set; }
        public string BillYMD               { get; set; }
        public string BillAdminID           { get; set; }
        public string BillAdminName         { get; set; }
        public string BillDate              { get; set; }
        public string NtsConfirmNum         { get; set; }
        public string IssuSeqNo             { get; set; }
        public string Note                  { get; set; }
        public int    ClosingKind           { get; set; }
        public string ClosingKindM          { get; set; }
        public string ClosingAdminID        { get; set; }
        public string ClosingAdminName      { get; set; }
        public string ClosingYMD            { get; set; }
        public string ClosingDate           { get; set; }
        public int    PayStatus             { get; set; }
        public string PayStatusM            { get; set; }
        public string PayYMD                { get; set; }
        public string PayChargeName         { get; set; }
        public string PayChargeCell         { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdAdminName          { get; set; }
        public string UpdDate               { get; set; }
        public string BtnBillProc           { get; set; }
        public string BtnCardProc           { get; set; }
        public string MinBillWrite          { get; set; }
        public string PickupYMDFrom         { get; set; }
        public string PickupYMDTo           { get; set; }
        public int    OrderCnt              { get; set; }
        public string CsAdminNames          { get; set; }
    }

    public class ReqSaleClosingList
    {
        public long   SaleClosingSeqNo      { get; set; }
        public long   PayClientCode         { get; set; }
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string CsAdminID             { get; set; }
        public string PayClientName         { get; set; }
        public string ClosingAdminName      { get; set; }
        public int    ClosingKind           { get; set; }
        public string AccessCenterCode      { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResSaleClosingList
    {
        public List<SaleClosingGridModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }

    public class SaleClosingOrderGridModel
    {
        public string OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public string CenterName              { get; set; }
        public string OrderItemCode           { get; set; }
        public string OrderItemCodeM          { get; set; }
        public string OrderLocationCode       { get; set; }
        public string OrderLocationCodeM      { get; set; }
        public string OrderClientCode         { get; set; }
        public string OrderClientName         { get; set; }
        public string OrderClientChargeName   { get; set; }
        public string PayClientCode           { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorCode           { get; set; }
        public string ConsignorName           { get; set; }
        public string PickupYMD               { get; set; }
        public string PickupPlace             { get; set; }
        public string GetYMD                  { get; set; }
        public string GetPlace                { get; set; }
        public string AcceptDate              { get; set; }
        public string AcceptAdminName         { get; set; }
        public string UpdDate                 { get; set; }
        public string UpdAdminName            { get; set; }
        public string SaleCarryoverFlag       { get; set; }
        public double SaleOrgAmt              { get; set; }
        public double SaleSupplyAmt           { get; set; }
        public double SaleTaxAmt              { get; set; }
        public string SaleClosingSeqNo        { get; set; }
        public string ClosingFlag             { get; set; }
        public string ClosingKind             { get; set; }
        public string ClosingKindM            { get; set; }
        public string ClosingAdminName        { get; set; }
        public string ClosingDate             { get; set; }
        public double CBM                     { get; set; }
        public int    Volume                  { get; set; }
        public double Weight                  { get; set; }
        public string Hawb                    { get; set; }
        public string Mawb                    { get; set; }
        public string Nation                  { get; set; }
        public string Quantity                { get; set; }
        public string CarNo                   { get; set; }
        public double AdvanceSupplyAmt3       { get; set; }
        public double AdvanceSupplyAmt4       { get; set; }
        public string DeliveryLocationCode    { get; set; }
        public string DeliveryLocationCodeM   { get; set; }
    }

    public class ReqSaleClosingOrderList
    {
        public int    CenterCode       { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResSaleClosingOrderList
    {
        public List<SaleClosingOrderGridModel> list      { get; set; }
        public int                             RecordCnt { get; set; }
    }

    public class ReqSaleClosingBillInfoUpd
    {
        public int    CenterCode        { get; set; }
        public string SaleClosingSeqNos { get; set; }
        public int    BillStatus        { get; set; }
        public int    BillKind          { get; set; }
        public string BillChargeName    { get; set; }
        public string BillChargeTelNo   { get; set; }
        public string BillChargeEmail   { get; set; }
        public string BillWrite         { get; set; }
        public string BillYMD           { get; set; }
        public string BillAdminID       { get; set; }
        public string BillAdminName     { get; set; }
        public string NtsConfirmNum     { get; set; }
    }

    public class ReqSaleClosingNoteUpd
    {
        public int    CenterCode       { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string Note             { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
    }

    public class ReqSaleClosingCardUpd
    {
        public int    CenterCode       { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public long   PGPayNo          { get; set; }
        public string PayChargeName    { get; set; }
        public string PayChargeCell    { get; set; }
        public int    RouteType        { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
    }

    public class ResSaleClosingCardUpd
    {
        public long CardSeqNo { get; set; }
    }

    public class ReqSaleClosingCardCnl
    {
        public int    CenterCode       { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string ChkPermFlag      { get; set; }
        public int    CardPayStatus    { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
    }

    public class ReqSaleClosingPayList
    {
        public int    CenterCode       { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public string AccessCenterCode { get; set; }
    }


    public class SaleClosingPayModel
    {
        public string ItemCode         { get; set; }
        public string ItemCodeM        { get; set; }
        public long   SaleClosingSeqNo { get; set; }
        public double OrgAmt           { get; set; }
        public double SupplyAmt        { get; set; }
        public double TaxAmt           { get; set; }
    }

    public class ResSaleClosingPayList
    {
        public List<SaleClosingPayModel> list      { get; set; }
        public int                       RecordCnt { get; set; }
    }
    

    public class ReqSaleClosingBillCnl
    {
        public int    CenterCode        { get; set; }
        public string SaleClosingSeqNos { get; set; }
        public string AdminID           { get; set; }
    }

    public class ResSaleClosingBillCnl
    {
        public int TotalCnt  { get; set; } = 0;
        public int CancelCnt { get; set; } = 0;
    }
}