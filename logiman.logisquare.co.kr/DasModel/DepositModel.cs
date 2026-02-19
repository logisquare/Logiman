using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class OrderAdvanceGridModel
    {
        public int    CenterCode              { get; set; }
        public string CenterName              { get; set; }
        public string OrderNo                 { get; set; }
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
        public string AcceptDate              { get; set; }
        public string AcceptAdminID           { get; set; }
        public string AcceptAdminName         { get; set; }
        public string AdvanceSeqNo            { get; set; }
        public int    PayType                 { get; set; }
        public string PayTypeM                { get; set; }
        public string ItemCode                { get; set; }
        public string ItemNameM               { get; set; }
        public double AdvanceOrgAmt           { get; set; }
        public double AdvanceSupplyAmt        { get; set; }
        public double AdvanceTaxAmt           { get; set; }
        public string ClientCode              { get; set; }
        public string ClientName              { get; set; }
        public string DepositClosingSeqNo     { get; set; }
        public string DepositClientCode       { get; set; }
        public string DepositClientName       { get; set; }
        public int    DepositType             { get; set; }
        public string DepositTypeM            { get; set; }
        public string DepositYMD              { get; set; }
        public string DepositNote             { get; set; }
        public string Hawb                    { get; set; }
        public string CntrNo                  { get; set; }
        public string ClosingFlag             { get; set; }
        public string ClosingDate             { get; set; }
        public string ClosingAdminID          { get; set; }
        public string ClosingAdminName        { get; set; }

    }

    public class ReqOrderAdvanceList
    {
        public long   DepositClosingSeqNo     { get; set; }
        public int    CenterCode              { get; set; }
        public long   OrderNo                 { get; set; }
        public long   ClientCode              { get; set; }
        public int    PayType                 { get; set; }
        public int    DateType                { get; set; }
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
        public string AcceptAdminName         { get; set; }
        public double OrgAmt                  { get; set; }
        public string ClientName              { get; set; }
        public string DepositClientName       { get; set; }
        public double DepositAmt              { get; set; }
        public string DepositNote             { get; set; }
        public string AccessCenterCode        { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class ResOrderAdvanceList
    {
        public List<OrderAdvanceGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class PayDepositModel
    {
        public int    CenterCode           { get; set; }
        public long   ClientCode           { get; set; }
        public string ClientName           { get; set; }
        public string AdvanceSeqNos        { get; set; }
        public int    DepositType          { get; set; }
        public string InputYMD             { get; set; }
        public string InputYM              { get; set; }
        public double Amt                  { get; set; }
        public string Note                 { get; set; }
        public string SaleClosingSeqNos    { get; set; }
        public string RegAdminID           { get; set; }
        public string RegAdminName         { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
        public long   DepositSeqNo         { get; set; }
        public long   DepositClosingSeqNo  { get; set; }
        public string DepositClosingSeqNos { get; set; }
        public string DelAdminID           { get; set; }
        public string DelAdminName         { get; set; }
    }

    public class PayDepositGridModel
    {
        public string DepositSeqNo         { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string DepositClosingSeqNo  { get; set; }
        public string ClientCode           { get; set; }
        public string ClientName           { get; set; }
        public int    DepositType          { get; set; }
        public string DepositTypeM         { get; set; }
        public string InputYMD             { get; set; }
        public string InputYM              { get; set; }
        public double Amt                  { get; set; }
        public string Note                 { get; set; }
        public string RegAdminID           { get; set; }
        public string RegAdminName         { get; set; }
        public string RegDate              { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
        public string UpdDate              { get; set; }
        public string DelFlag              { get; set; }
        public string DelAdminID           { get; set; }
        public string DelAdminName         { get; set; }
        public string DelDate              { get; set; }
        public string MatchingClosingSeqNo { get; set; }
    }

    public class ReqPayDepositList
    {
        public long   DepositClosingSeqNo { get; set; }
        public long   DepositSeqNo        { get; set; }
        public long   CenterCode          { get; set; }
        public long   ClientCode          { get; set; }
        public string ClientName          { get; set; }
        public double DepositAmt          { get; set; }
        public string DepositTypes        { get; set; }
        public string DateFrom            { get; set; }
        public string DateTo              { get; set; }
        public string Note                { get; set; }
        public string NoMatchingFlag      { get; set; }
        public string AccessCenterCode    { get; set; }
        public int    PageSize            { get; set; }
        public int    PageNo              { get; set; }
    }

    public class ResPayDepositList
    {
        public List<PayDepositGridModel> list      { get; set; }
        public int                       RecordCnt { get; set; }
    }

    public class DepositClientGridModel
    {
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public string ClientNameSimple      { get; set; }
        public string ClientCorpNo          { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public string ClientPayDay          { get; set; }
        public string ClientPayDayM         { get; set; }
        public double TotalMisuAmt          { get; set; }
        public double MisuAmt               { get; set; }
        public int    NoMatchingCnt         { get; set; }
        public string CsAdminNames          { get; set; }
        public string CsClosingAdminNames   { get; set; }
    }

    public class ReqDepositClientList
    {
        public long   CenterCode         { get; set; }
        public string ClientName         { get; set; }
        public string CsAdminName        { get; set; }
        public string CsClosingAdminName { get; set; }
        public string AccessCenterCode   { get; set; }
    }

    public class ResDepositClientList
    {
        public List<DepositClientGridModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class DepositClientTotalGridModel
    {
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public string InputYM               { get; set; }
        public double SaleAmt               { get; set; }
        public double SaleDepositAmt        { get; set; }
        public double AdvanceAmt            { get; set; }
        public double AdvanceDepositAmt     { get; set; }
        public double SetOffAmt             { get; set; }
    }

    public class ReqDepositClientTotalList
    {
        public int    CenterCode       { get; set; }
        public long   ClientCode       { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResDepositClientTotalList
    {
        public List<DepositClientTotalGridModel> list      { get; set; }
        public int                               RecordCnt { get; set; }
    }

    public class DepositClosingGridModel
    {
        public string SaleClosingSeqNo     { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string ClientCode           { get; set; }
        public string ClientName           { get; set; }
        public double OrgAmt               { get; set; }
        public double SupplyAmt            { get; set; }
        public double TaxAmt               { get; set; }
        public string PickupYMDFrom        { get; set; }
        public string PickupYMDTo          { get; set; }
        public int    OrderCnt             { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string BillWrite            { get; set; }
        public string BillWriteYM          { get; set; }
        public string BillYMD              { get; set; }
        public int    ClosingKind          { get; set; }
        public string ClosingKindM         { get; set; }
        public string ClosingYMD           { get; set; }
        public string ClosingDate          { get; set; }
        public string ClosingAdminID       { get; set; }
        public string ClosingAdminName     { get; set; }
        public string MatchingClosingSeqNo { get; set; }
    }

    public class ReqDepositClosingList
    {
        public long   SaleClosingSeqNo { get; set; }
        public long   ClientCode       { get; set; }
        public int    CenterCode       { get; set; }
        public int    DateType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string ClosingKinds     { get; set; }
        public string NoMatchingFlag   { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResDepositClosingList
    {
        public List<DepositClosingGridModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class PayMisuGridModel
    {
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string Y                     { get; set; }
        public double TotalUnpaidAmt        { get; set; }
        public double SaleAmt1              { get; set; }
        public double SaleDepositAmt1       { get; set; }
        public double AdvanceAmt1           { get; set; }
        public double AdvanceDepositAmt1    { get; set; }
        public double SaleAmt2              { get; set; }
        public double SaleDepositAmt2       { get; set; }
        public double AdvanceAmt2           { get; set; }
        public double AdvanceDepositAmt2    { get; set; }
        public double SaleAmt3              { get; set; }
        public double SaleDepositAmt3       { get; set; }
        public double AdvanceAmt3           { get; set; }
        public double AdvanceDepositAmt3    { get; set; }
        public double SaleAmt4              { get; set; }
        public double SaleDepositAmt4       { get; set; }
        public double AdvanceAmt4           { get; set; }
        public double AdvanceDepositAmt4    { get; set; }
        public double SaleAmt5              { get; set; }
        public double SaleDepositAmt5       { get; set; }
        public double AdvanceAmt5           { get; set; }
        public double AdvanceDepositAmt5    { get; set; }
        public double SaleAmt6              { get; set; }
        public double SaleDepositAmt6       { get; set; }
        public double AdvanceAmt6           { get; set; }
        public double AdvanceDepositAmt6    { get; set; }
        public double SaleAmt7              { get; set; }
        public double SaleDepositAmt7       { get; set; }
        public double AdvanceAmt7           { get; set; }
        public double AdvanceDepositAmt7    { get; set; }
        public double SaleAmt8              { get; set; }
        public double SaleDepositAmt8       { get; set; }
        public double AdvanceAmt8           { get; set; }
        public double AdvanceDepositAmt8    { get; set; }
        public double SaleAmt9              { get; set; }
        public double SaleDepositAmt9       { get; set; }
        public double AdvanceAmt9           { get; set; }
        public double AdvanceDepositAmt9    { get; set; }
        public double SaleAmt10             { get; set; }
        public double SaleDepositAmt10      { get; set; }
        public double AdvanceAmt10          { get; set; }
        public double AdvanceDepositAmt10   { get; set; }
        public double SaleAmt11             { get; set; }
        public double SaleDepositAmt11      { get; set; }
        public double AdvanceAmt11          { get; set; }
        public double AdvanceDepositAmt11   { get; set; }
        public double SaleAmt12             { get; set; }
        public double SaleDepositAmt12      { get; set; }
        public double AdvanceAmt12          { get; set; }
        public double AdvanceDepositAmt12   { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public string ClientNameSimple      { get; set; }
        public string ClientCorpNo          { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public string ClientPayDay          { get; set; }
        public string ClientPayDayM         { get; set; }
        public string Note                  { get; set; }
        public string CsAdminNames          { get; set; }
        public string CsClosingAdminNames   { get; set; }
    }

    public class ReqPayMisuList
    {
        public int    CenterCode           { get; set; }
        public string Year                 { get; set; }
        public int    ClientBusinessStatus { get; set; }
        public string ClientName           { get; set; }
        public string AccessCenterCode     { get; set; }
    }

    public class ResPayMisuList
    {
        public List<PayMisuGridModel> list      { get; set; }
        public int                    RecordCnt { get; set; }
    }

    public class ReqPayMisuIns
    {
        public int    CenterCode   { get; set; }
        public string YM           { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
    }

    public class PayMisuNoteModel
    {
        public long   NoteSeqNo    { get; set; }
        public int    CenterCode   { get; set; }
        public long   ClientCode   { get; set; }
        public string NoteYMD      { get; set; }
        public string Note         { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdAdminName { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }
    }

    public class PayMisuNoteGridModel
    {
        public string NoteSeqNo    { get; set; }
        public int    CenterCode   { get; set; }
        public string CenterName   { get; set; }
        public string ClientCode   { get; set; }
        public string ClientName   { get; set; }
        public string NoteYMD      { get; set; }
        public string Note         { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string RegDate      { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdAdminName { get; set; }
        public string UpdDate      { get; set; }
        public string DelFlag      { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }
        public string DelDate      { get; set; }
    }

    public class ReqPayMisuNoteList
    {
        public long   NoteSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public long   ClientCode       { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string Note             { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResPayMisuNoteList
    {
        public List<PayMisuNoteGridModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }


    public class ReqPayMatchingIns
    {
        public int    CenterCode           { get; set; }
        public long   ClientCode           { get; set; }
        public string SaleClosingSeqNos    { get; set; }
        public string DepositClosingSeqNos { get; set; }
        public string RegAdminID           { get; set; }
        public string RegAdminName         { get; set; }
    }

    public class ResPayMatchingIns
    {
        public double SaleOrgAmt           { get; set; }
        public double DepositAmt           { get; set; }
        public long   MatchingClosingSeqNo { get; set; }
    }

    public class ReqPayMatchingDel
    {
        public int    CenterCode           { get; set; }
        public long   ClientCode           { get; set; }
        public long   MatchingClosingSeqNo { get; set; }
        public long   SaleClosingSeqNo     { get; set; }
        public long   DepositClosingSeqNo  { get; set; }
        public string DepositFlag          { get; set; }
        public string DelAdminID           { get; set; }
        public string DelAdminName         { get; set; }
    }

    public class ReqPayDepositExcelChk
    {
        public int    CenterCode   { get; set; }
        public string ClientCorpNo { get; set; }
        public string InputYMD     { get; set; }
        public string AdminID      { get; set; }
    }

    public class ResPayDepositExcelChk
    {
        public string ClientExistsFlag { get; set; }
        public long   ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public string ClientNameSimple { get; set; }
        public string ClientPayDay     { get; set; }
        public string ClientPayDayM    { get; set; }
        public string InputYM          { get; set; }
    }
}