using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class PurchaseCarCompanyGridModel
    {
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public string ComCode            { get; set; }
        public string ComName            { get; set; }
        public string ComCeoName         { get; set; }
        public string ComCorpNo          { get; set; }
        public string ComKindM           { get; set; }
        public int    ComStatus          { get; set; }
        public string ComStatusM         { get; set; }
        public string ComCloseYMD        { get; set; }
        public int    ComTaxKind         { get; set; }
        public string ComTaxKindM        { get; set; }
        public string PayDay             { get; set; }
        public string CooperatorFlag     { get; set; }
        public string BankCode           { get; set; }
        public string BankName           { get; set; }
        public string SearchAcctNo       { get; set; }
        public string EncAcctNo          { get; set; }
        public string AcctName           { get; set; }
        public string AcctValidFlag      { get; set; }
        public double PurchaseOrgAmt     { get; set; }
        public double PurchaseSupplyAmt  { get; set; }
        public double PurchaseTaxAmt     { get; set; }
        public int    PurchaseCnt        { get; set; }
        public int    ClosingPurchaseCnt { get; set; }
        public string MinBillWrite       { get; set; }
        public int    NoMatchTaxCnt      { get; set; }
        public string NoMatchTaxInfo     { get; set; }
    }

    public class PurchaseCarCompanyPayGridModel
    {
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string OrderNo               { get; set; }
        public string OrderItemCode         { get; set; }
        public string OrderItemCodeM        { get; set; }
        public string OrderLocationCode     { get; set; }
        public string OrderLocationCodeM    { get; set; }
        public string OrderClientCode       { get; set; }
        public string OrderClientName       { get; set; }
        public string PayClientCode         { get; set; }
        public string PayClientName         { get; set; }
        public string ConsignorCode         { get; set; }
        public string ConsignorName         { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupPlace           { get; set; }
        public string GetYMD                { get; set; }
        public string GetPlace              { get; set; }
        public string ComCode               { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public string DeliveryLocationCodeM { get; set; }
        public int    CarDivType            { get; set; }
        public string CarDivTypeM           { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string ComName               { get; set; }
        public string ComCeoName            { get; set; }
        public string ComCorpNo             { get; set; }
        public int    ComStatus             { get; set; }
        public string ComStatusM            { get; set; }
        public string ComCloseYMD           { get; set; }
        public int    ComTaxKind            { get; set; }
        public string ComTaxKindM           { get; set; }
        public string PayDay                { get; set; }
        public string CooperatorFlag        { get; set; }
        public string BankCode              { get; set; }
        public string BankName              { get; set; }
        public string SearchAcctNo          { get; set; }
        public string AcctName              { get; set; }
        public double PurchaseOrgAmt        { get; set; }
        public double PurchaseSupplyAmt     { get; set; }
        public double PurchaseTaxAmt        { get; set; }
        public int    BillStatus            { get; set; }
        public string BillStatusM           { get; set; }
        public int    BillKind              { get; set; }
        public string BillKindM             { get; set; }
        public string PurchaseClosingSeqNo  { get; set; }
        public string ClosingFlag           { get; set; }
        public int    SendStatus            { get; set; }
        public string SendStatusM           { get; set; }
        public int    SendType              { get; set; }
        public string SendTypeM             { get; set; }
        public string ClosingDate           { get; set; }
        public string ClosingAdminID        { get; set; }
        public string ClosingAdminName      { get; set; }
        public int    Length                { get; set; }
        public double CBM                   { get; set; }
        public int    Volume                { get; set; }
        public double Weight                { get; set; }
        public string DispatchSeqNo         { get; set; }
        public string NtsConfirmNum         { get; set; }
        public int    InsureExceptKind      { get; set; }
        public string InsureExceptKindM     { get; set; }
        public string InsureTargetFlag      { get; set; }
    }


    public class ReqPurchaseCarCompanyList
    {
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string OrderItemCodes        { get; set; }
        public int    CarDivType            { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string CooperatorFlag        { get; set; }
        public string ClosingFlag           { get; set; }
        public string MyOrderFlag           { get; set; }
        public string AdminID               { get; set; }
        public string AccessCenterCode      { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResPurchaseCarCompanyList
    {
        public List<PurchaseCarCompanyGridModel> list      { get; set; }
        public int                               RecordCnt { get; set; }
    }

    public class ReqPurchaseCarCompanyPayList
    {
        public int    CenterCode            { get; set; }
        public long   ComCode               { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string OrderItemCodes        { get; set; }
        public int    CarDivType            { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string CooperatorFlag        { get; set; }
        public string ClosingFlag           { get; set; }
        public string MyOrderFlag           { get; set; }
        public string AdminID               { get; set; }
        public string AccessCenterCode      { get; set; }
    }

    public class ResPurchaseCarCompanyPayList
    {
        public List<PurchaseCarCompanyPayGridModel> list      { get; set; }
        public int                                  RecordCnt { get; set; }
    }

    public class ReqPurchaseClosingCarIns
    {
        public int    CenterCode       { get; set; }
        public string DispatchSeqNos1  { get; set; }
        public string DispatchSeqNos2  { get; set; }
        public string DispatchSeqNos3  { get; set; }
        public string DispatchSeqNos4  { get; set; }
        public string DispatchSeqNos5  { get; set; }
        public string DispatchSeqNos6  { get; set; }
        public string DispatchSeqNos7  { get; set; }
        public string DispatchSeqNos8  { get; set; }
        public int    BillStatus       { get; set; }
        public int    BillKind         { get; set; }
        public string BillWrite        { get; set; }
        public string BillYMD          { get; set; }
        public string BillDate         { get; set; }
        public string NtsConfirmNum    { get; set; }
        public double PurchaseOrgAmt   { get; set; }
        public double DeductAmt        { get; set; }
        public string DeductReason     { get; set; }
        public double IssueTaxAmt      { get; set; }
        public string InsureFlag       { get; set; }
        public string Note             { get; set; }
        public string ClosingAdminID   { get; set; }
        public string ClosingAdminName { get; set; }
    }

    public class ResPurchaseClosingCarIns
    {
        public long   PurchaseClosingSeqNo { get; set; }
        public double PurchaseOrgAmt       { get; set; }
        public double PurchaseDeductAmt    { get; set; }
        public string SendPlanYMD          { get; set; }
    }

    public class ReqPurchaseClosingCnl
    {
        public int    CenterCode            { get; set; }
        public string PurchaseClosingSeqNos { get; set; }
        public string ChkPermFlag           { get; set; }
        public string CnlAdminID            { get; set; }
        public string CnlAdminName          { get; set; }
    }

    public class PurchaseQuickPayGridModel
    {
        public string DispatchSeqNo         { get; set; }
        public string PurchaseSeqNo         { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string OrderNo               { get; set; }
        public string OrderItemCode         { get; set; }
        public string OrderItemCodeM        { get; set; }
        public string OrderLocationCode     { get; set; }
        public string OrderLocationCodeM    { get; set; }
        public string OrderClientCode       { get; set; }
        public string OrderClientName       { get; set; }
        public string PayClientCode         { get; set; }
        public string PayClientName         { get; set; }
        public string ConsignorCode         { get; set; }
        public string ConsignorName         { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupPlace           { get; set; }
        public string GetYMD                { get; set; }
        public string GetPlace              { get; set; }
        public string ComCode               { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public string DeliveryLocationCodeM { get; set; }
        public int    CarDivType            { get; set; }
        public string CarDivTypeM           { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public int    QuickType             { get; set; }
        public string QuickTypeM            { get; set; }
        public string ComName               { get; set; }
        public string ComCeoName            { get; set; }
        public string ComCorpNo             { get; set; }
        public int    ComStatus             { get; set; }
        public string ComStatusM            { get; set; }
        public string ComCloseYMD           { get; set; }
        public int    ComTaxKind            { get; set; }
        public string ComTaxKindM           { get; set; }
        public string PayDay                { get; set; }
        public string CooperatorFlag        { get; set; }
        public string BankCode              { get; set; }
        public string BankName              { get; set; }
        public string SearchAcctNo          { get; set; }
        public string EncAcctNo             { get; set; }
        public string AcctName              { get; set; }
        public string AcctValidFlag         { get; set; }
        public double PurchaseOrgAmt        { get; set; }
        public double PurchaseSupplyAmt     { get; set; }
        public double PurchaseTaxAmt        { get; set; }
        public double QuickPaySupplyFee     { get; set; }
        public double QuickPayTaxFee        { get; set; }
        public int    BillStatus            { get; set; }
        public string BillStatusM           { get; set; }
        public int    BillKind              { get; set; }
        public string BillKindM             { get; set; }
        public string PurchaseClosingSeqNo  { get; set; }
        public string ClosingFlag           { get; set; }
        public int    SendStatus            { get; set; }
        public string SendStatusM           { get; set; }
        public int    SendType              { get; set; }
        public string SendTypeM             { get; set; }
        public string ClosingAdminID        { get; set; }
        public string ClosingAdminName      { get; set; }
        public string ClosingDate           { get; set; }
        public double Length                { get; set; }
        public double CBM                   { get; set; }
        public int    Volume                { get; set; }
        public double Weight                { get; set; }
        public string NtsConfirmNum         { get; set; }
        public string AcceptAdminName       { get; set; }
        public string DispatchAdminName     { get; set; }
        public int    NoMatchTaxCnt         { get; set; }
        public string NoMatchTaxInfo        { get; set; }
        public int    InsureExceptKind      { get; set; }
        public string InsureExceptKindM     { get; set; }
        public string ComKindM              { get; set; }
        public string InsureTargetFlag      { get; set; }
    }

    public class ReqPurchaseQuickPayList
    {
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string OrderItemCodes        { get; set; }
        public string ConsignorName         { get; set; }
        public int    QuickType             { get; set; }
        public int    CarDivType            { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string ClosingFlag           { get; set; }
        public string AcceptAdminName       { get; set; }
        public string DispatchAdminName     { get; set; }
        public string AccessCenterCode      { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResPurchaseQuickPayList
    {
        public List<PurchaseQuickPayGridModel> list      { get; set; }
        public int                             RecordCnt { get; set; }
    }

    public class PurchaseClosingGridModel
    {
        public string PurchaseClosingSeqNo { get; set; }
        public string ComName              { get; set; }
        public string CarNo                { get; set; }
        public string DriverName           { get; set; }
        public string DriverCell           { get; set; }
        public double OrgAmt               { get; set; }
        public double SupplyAmt            { get; set; }
        public double TaxAmt               { get; set; }
        public double DeductAmt            { get; set; }
        public string DeductReason         { get; set; }
        public string DeductFlag           { get; set; }
        public double SendAmt              { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string BillWrite            { get; set; }
        public string BillYMD              { get; set; }
        public string BillDate             { get; set; }
        public string BtnRegBill           { get; set; }
        public string NtsConfirmNum        { get; set; }
        public int    SendStatus           { get; set; }
        public string SendStatusM          { get; set; }
        public int    SendType             { get; set; }
        public string SendTypeM            { get; set; }
        public string SendPlanYMD          { get; set; }
        public string SendYMD              { get; set; }
        public string SendAdminID          { get; set; }
        public string SendAdminName        { get; set; }
        public string SendDate             { get; set; }
        public string SendBankCode         { get; set; }
        public string SendBankName         { get; set; }
        public string SendEncAcctNo        { get; set; }
        public string SendSearchAcctNo     { get; set; }
        public string SendAcctNo           { get; set; }
        public string SendAcctName         { get; set; }
        public string Note                 { get; set; }
        public string ClosingAdminID       { get; set; }
        public string ClosingAdminName     { get; set; }
        public string ClosingYMD           { get; set; }
        public string ClosingDate          { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
        public string UpdDate              { get; set; }
        public string ComCode              { get; set; }
        public string ComCorpNo            { get; set; }
        public string ComCeoName           { get; set; }
        public string ComBizType           { get; set; }
        public string ComBizClass          { get; set; }
        public string ComTelNo             { get; set; }
        public string ComFaxNo             { get; set; }
        public string ComEmail             { get; set; }
        public string ComAddr              { get; set; }
        public string ComAddr1             { get; set; }
        public string ComAddrDtl           { get; set; }
        public string ComPost              { get; set; }
        public int    ComStatus            { get; set; }
        public string ComStatusM           { get; set; }
        public string ComUpdYMD            { get; set; }
        public string ComCloseYMD          { get; set; }
        public int    ComTaxKind           { get; set; }
        public string ComTaxKindM          { get; set; }
        public string ComTaxMsg            { get; set; }
        public string CardAgreeFlag        { get; set; }
        public string CardAgreeYMD         { get; set; }
        public string BankCode             { get; set; }
        public string BankName             { get; set; }
        public string EncAcctNo            { get; set; }
        public string SearchAcctNo         { get; set; }
        public string AcctNo               { get; set; }
        public string AcctName             { get; set; }
        public string AcctValidFlag        { get; set; }
        public string CooperatorFlag       { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string CeoName              { get; set; }
        public string CorpNo               { get; set; }
        public string BizType              { get; set; }
        public string BizClass             { get; set; }
        public string TelNo                { get; set; }
        public string Addr                 { get; set; }
        public string PickupYMDFrom        { get; set; }
        public string PickupYMDTo          { get; set; }
        public int    OrderCnt             { get; set; }
        public double InputDeductAmt       { get; set; }
        public string InsureFlag           { get; set; }
        public double TransCost            { get; set; }
        public double InsureRateAmt        { get; set; }
        public double InsureReduceAmt      { get; set; }
        public double DriverInsureAmt      { get; set; }
        public double NotiDriverInsureAmt  { get; set; }
        public double CenterInsureAmt      { get; set; }
        public double NotiCenterInsureAmt  { get; set; }
        public string ComKindM             { get; set; }
    }


    public class ReqPurchaseClosingList
    {
        public long   PurchaseClosingSeqNo  { get; set; }
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string OrderItemCodes        { get; set; }
        public int    SendStatus            { get; set; }
        public int    SendType              { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string ClosingAdminName      { get; set; }
        public string QuickFlag             { get; set; }
        public string DeductFlag            { get; set; }
        public string InsureFlag            { get; set; }
        public string AccessCenterCode      { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResPurchaseClosingList
    {
        public List<PurchaseClosingGridModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class PurchaseClosingPayGridModel
    {
        public string OrderNo               { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string OrderItemCode         { get; set; }
        public string OrderItemCodeM        { get; set; }
        public string OrderLocationCode     { get; set; }
        public string OrderLocationCodeM    { get; set; }
        public string OrderClientCode       { get; set; }
        public string OrderClientName       { get; set; }
        public string PayClientCode         { get; set; }
        public string PayClientName         { get; set; }
        public string ConsignorCode         { get; set; }
        public string ConsignorName         { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupPlace           { get; set; }
        public string GetYMD                { get; set; }
        public string GetPlace              { get; set; }
        public string AcceptAdminName       { get; set; }
        public double PurchaseOrgAmt        { get; set; }
        public double PurchaseSupplyAmt     { get; set; }
        public double PurchaseTaxAmt        { get; set; }
        public string DispatchSeqNo         { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public string DeliveryLocationCodeM { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public string CarNo                 { get; set; }
        public int    SendStatus            { get; set; }
        public string SendStatusM           { get; set; }
        public int    SendType              { get; set; }
        public string SendTypeM             { get; set; }
        public string SendPlanYMD           { get; set; }
        public string SendYMD               { get; set; }
        public string SendAdminID           { get; set; }
        public string SendAdminName         { get; set; }
        public string SendDate              { get; set; }
        public string PurchaseClosingSeqNo  { get; set; }
        public string ClosingAdminName      { get; set; }
        public string ClosingDate           { get; set; }
        public int    CarDivType            { get; set; }
        public string CarDivTypeM           { get; set; }
        public string ComCode               { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string BankCode              { get; set; }
        public string BankName              { get; set; }
        public string EncAcctNo             { get; set; }
        public string SearchAcctNo          { get; set; }
        public string AcctName              { get; set; }
        public string Note                  { get; set; }
        public int    BillKind              { get; set; }
        public string BillKindM             { get; set; }
        public string NtsConfirmNum         { get; set; }
        public int    BillStatus            { get; set; }
        public string BillStatusM           { get; set; }
        public double CBM                   { get; set; }
        public int    Volume                { get; set; }
        public double Weight                { get; set; }
        public string Hawb                  { get; set; }
        public string Mawb                  { get; set; }
        public int    InsureExceptKind      { get; set; }
        public string InsureExceptKindM     { get; set; }
        public string InsureTargetFlag      { get; set; }
    }

    public class ReqPurchaseClosingPayList
    {
        public long   PurchaseClosingSeqNo  { get; set; }
        public int    CenterCode            { get; set; }
        public string AccessCenterCode      { get; set; }
    }

    public class ResPurchaseClosingPayList
    {
        public List<PurchaseClosingPayGridModel> list      { get; set; }
        public int                               RecordCnt { get; set; }
    }
    
    public class PurchaseClosingPayMonthModel
    {
        public int    CenterCode     { get; set; }
        public string CenterName     { get; set; }
        public string PickupYM       { get; set; }
        public int    PurchaseCnt    { get; set; }
        public double PurchaseOrgAmt { get; set; }
    }

    public class ReqPurchaseClosingPayMonthList
    {
        public int    CenterCode       { get; set; }
        public string Year             { get; set; }
        public string ClosingFlag      { get; set; }
        public string QuickFlag        { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResPurchaseClosingPayMonthList
    {
        public List<PurchaseClosingPayMonthModel> list      { get; set; }
        public int                                RecordCnt { get; set; }
    }

    public class ReqPurchaseClosingSendInfoUpd
    {
        public int    CenterCode           { get; set; }
        public string PurchaseClosingSeqNo { get; set; } 
        public int    SendStatus           { get; set; } //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
        public int    SendType             { get; set; } //결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
        public string ReqYMD               { get; set; } //송금신청이면 SendPlanYMD, 송금완료면 SendYMD
        public string ChkPermFlag          { get; set; }
        public string SendAdminID          { get; set; }
        public string SendAdminName        { get; set; }
    }

    public class ReqPurchaseClosingNoteUpd
    {
        public int    CenterCode           { get; set; }
        public long   PurchaseClosingSeqNo { get; set; }
        public string Note                 { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
    }

    public class ReqPurchaseClosingCardUpd
    {
        public int    CenterCode            { get; set; }
        public string PurchaseClosingSeqNos { get; set; }
        public int    RouteType             { get; set; } //신청 경로(1 : 알림톡, 2 : 머핀트럭, 3 : TMS)
        public string AdminID               { get; set; }
        public string AdminName             { get; set; }
        public string AdminCell             { get; set; }
    }

    public class ResPurchaseClosingCardUpd
    {
        public int TotalCnt   { get; set; }
        public int SuccCnt    { get; set; }
        public int FailCnt    { get; set; }
    }

    public class ReqPurchaseClosingBillInfoUpd
    {
        public int    CenterCode           { get; set; }
        public string PurchaseClosingSeqNos { get; set; }
        public int    BillStatus           { get; set; }
        public int    BillKind             { get; set; }
        public string BillWrite            { get; set; }
        public string BillYMD              { get; set; }
        public string NtsConfirmNum        { get; set; }
        public string ChkPermFlag          { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
    }

    public class PurchaseClosingSendModel
    {
        public int    SeqNo      { get; set; }
        public int    CenterCode  { get; set; }
        public string CenterName  { get; set; }
        public string SendPlanYMD { get; set; }
        public int    AllCnt      { get; set; }
        public double AllAmt      { get; set; }
        public int    SendCnt1    { get; set; }
        public double SendAmt1    { get; set; }
        public int    SendCnt2    { get; set; }
        public double SendAmt2    { get; set; }
        public int    SendCnt3    { get; set; }
        public double SendAmt3    { get; set; }
    }
    
    public class ReqPurchaseClosingSendList
    {
        public long   PurchaseClosingSeqNo  { get; set; }
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string OrderItemCodes        { get; set; }
        public string DeductFlag            { get; set; }
        public string InsureFlag            { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string ClosingAdminName      { get; set; }
        public string AccessCenterCode      { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResPurchaseClosingSendList
    {
        public List<PurchaseClosingSendModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }


    public class PurchaseClientGridModel
    {
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public string ClientCode         { get; set; }
        public string ClientName         { get; set; }
        public string ClientCeoName      { get; set; }
        public string ClientCorpNo       { get; set; }
        public int    ClientStatus       { get; set; }
        public string ClientStatusM      { get; set; }
        public string ClientPayDay       { get; set; }
        public int    ClientTaxKind      { get; set; }
        public string ClientTaxKindM     { get; set; }
        public double PurchaseOrgAmt     { get; set; }
        public double PurchaseSupplyAmt  { get; set; }
        public double PurchaseTaxAmt     { get; set; }
        public int    PurchaseCnt        { get; set; }
        public int    ClosingPurchaseCnt { get; set; }
    }

    public class ReqPurchaseClientList
    {
        public int    CenterCode         { get; set; }
        public int    DateType           { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string OrderLocationCodes { get; set; }
        public string OrderItemCodes     { get; set; }
        public string ClosingFlag        { get; set; }
        public string ClientName         { get; set; }
        public string ClientCorpNo       { get; set; }
        public string AccessCenterCode   { get; set; }
        public int    PageSize           { get; set; }
        public int    PageNo             { get; set; }
    }

    public class ResPurchaseClientList
    {
        public List<PurchaseClientGridModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class PurchaseClientPayGridModel
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
        public string ConsignorCode        { get; set; }
        public string ConsignorName        { get; set; }
        public string PickupYMD            { get; set; }
        public string PickupPlace          { get; set; }
        public string GetYMD               { get; set; }
        public string GetPlace             { get; set; }
        public string PurchaseSeqNo        { get; set; }
        public string ClientCode           { get; set; }
        public string ClientName           { get; set; }
        public double PurchaseOrgAmt       { get; set; }
        public double PurchaseSupplyAmt    { get; set; }
        public double PurchaseTaxAmt       { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string PurchaseClosingSeqNo { get; set; }
        public string ClosingFlag          { get; set; }
        public int    SendStatus           { get; set; }
        public string SendStatusM          { get; set; }
        public int    SendType             { get; set; }
        public string SendTypeM            { get; set; }
        public string ClosingDate          { get; set; }
        public string ClosingAdminID       { get; set; }
        public string ClosingAdminName     { get; set; }
        public string DispatchSeqNo        { get; set; }
        public string NtsConfirmNum        { get; set; }
        public string ClientCeoName        { get; set; }
        public string ClientCorpNo         { get; set; }
        public int    ClientStatus         { get; set; }
        public string ClientStatusM        { get; set; }
        public int    ClientTaxKind        { get; set; }
        public string ClientTaxKindM       { get; set; }
        public string ClientPayDay         { get; set; }
        public int    Length               { get; set; }
        public double CBM                  { get; set; }
        public int    Volume               { get; set; }
        public double Weight               { get; set; }
    }

    public class ReqPurchaseClientPayList
    {
        public int    CenterCode         { get; set; }
        public long   ClientCode         { get; set; }
        public int    DateType           { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string OrderLocationCodes { get; set; }
        public string OrderItemCodes     { get; set; }
        public string ClosingFlag        { get; set; }
        public string ClientName         { get; set; }
        public string ClientCorpNo       { get; set; }
        public string AccessCenterCode   { get; set; }
    }

    public class ResPurchaseClientPayList
    {
        public List<PurchaseClientPayGridModel> list      { get; set; }
        public int                              RecordCnt { get; set; }
    }

    public class ReqPurchaseClosingClientIns
    {
        public int    CenterCode       { get; set; }
        public long   ClientCode       { get; set; }
        public string PurchaseSeqNos1  { get; set; }
        public string PurchaseSeqNos2  { get; set; }
        public string PurchaseSeqNos3  { get; set; }
        public string PurchaseSeqNos4  { get; set; }
        public string PurchaseSeqNos5  { get; set; }
        public double PurchaseOrgAmt   { get; set; }
        public double DeductAmt        { get; set; }
        public string DeductReason     { get; set; }
        public string Note             { get; set; }
        public string ClosingAdminID   { get; set; }
        public string ClosingAdminName { get; set; }
    }

    public class ResPurchaseClosingClientIns
    {
        public long   PurchaseClosingSeqNo { get; set; }
        public double PurchaseOrgAmt       { get; set; }
    }
    
    public class PurchaseClosingClientPayGridModel
    {
        public string OrderNo              { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string OrderItemCode        { get; set; }
        public string OrderItemCodeM       { get; set; }
        public string OrderLocationCode    { get; set; }
        public string OrderLocationCodeM   { get; set; }
        public string OrderClientCode      { get; set; }
        public string OrderClientName      { get; set; }
        public string PayClientCode        { get; set; }
        public string PayClientName        { get; set; }
        public string ConsignorCode        { get; set; }
        public string ConsignorName        { get; set; }
        public string PickupYMD            { get; set; }
        public string PickupPlace          { get; set; }
        public string GetYMD               { get; set; }
        public string GetPlace             { get; set; }
        public string AcceptAdminName      { get; set; }
        public double PurchaseOrgAmt       { get; set; }
        public double PurchaseSupplyAmt    { get; set; }
        public double PurchaseTaxAmt       { get; set; }
        public int    SendStatus           { get; set; }
        public string SendStatusM          { get; set; }
        public int    SendType             { get; set; }
        public string SendTypeM            { get; set; }
        public string SendPlanYMD          { get; set; }
        public string SendYMD              { get; set; }
        public string SendAdminID          { get; set; }
        public string SendAdminName        { get; set; }
        public string SendDate             { get; set; }
        public string PurchaseClosingSeqNo { get; set; }
        public string ClosingAdminName     { get; set; }
        public string ClosingDate          { get; set; }
        public string ClientCode           { get; set; }
        public string ClientName           { get; set; }
        public string ClientCorpNo         { get; set; }
        public string Note                 { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string NtsConfirmNum        { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public double CBM                  { get; set; }
        public int    Volume               { get; set; }
        public double Weight               { get; set; }
        public string Hawb                 { get; set; }
        public string Mawb                 { get; set; }
    }

    public class ReqPurchaseClosingClientPayList
    {
        public long   PurchaseClosingSeqNo { get; set; }
        public int    CenterCode           { get; set; }
        public string AccessCenterCode     { get; set; }
    }

    public class ResPurchaseClosingClientPayList
    {
        public List<PurchaseClosingClientPayGridModel> list      { get; set; }
        public int                                     RecordCnt { get; set; }
    }

    public class ReqPurchaseClosingDeductUpd
    {
        public int    CenterCode           { get; set; }
        public long   PurchaseClosingSeqNo { get; set; }
        public double InputDeductAmt       { get; set; }
        public string DeductReason         { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
    }

    public class ReqPurchaseCarCompanyInsureCheck
    {
        public int    CenterCode      { get; set; }
        public long   ComCode         { get; set; }
        public string InsureYMD       { get; set; }
        public string DispatchSeqNos1 { get; set; }
        public string DispatchSeqNos2 { get; set; }
        public string DispatchSeqNos3 { get; set; }
        public string DispatchSeqNos4 { get; set; }
        public string DispatchSeqNos5 { get; set; }
        public string DispatchSeqNos6 { get; set; }
        public string DispatchSeqNos7 { get; set; }
        public string DispatchSeqNos8 { get; set; }
        public string AdminID         { get; set; }
    }

    public class ResPurchaseCarCompanyInsureCheck
    {
        public string ApplyFlag       { get; set; }
        public double SupplyAmt       { get; set; }
        public double TransAmt        { get; set; }
        public double TransCost       { get; set; }
        public double InsureRateAmt   { get; set; }
        public double InsureReduceAmt { get; set; }
        public double InsurePayAmt    { get; set; }
        public double DriverInsureAmt { get; set; }
        public double CenterInsureAmt { get; set; }
    }

    public class PurchaseInsureGridModel
    {
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string OrderNo              { get; set; }
        public string DispatchSeqNo        { get; set; }
        public string ComCorpNo            { get; set; }
        public string CarNo                { get; set; }
        public string DriverName           { get; set; }
        public string DriverCell           { get; set; }
        public int    InsureExceptKind     { get; set; }
        public string InsureExceptKindM    { get; set; }
        public string RefSeqNo             { get; set; }
        public string DriverSeqNo          { get; set; }
        public string InformationFlag      { get; set; }
        public string InformationFlagM     { get; set; }
        public string AgreementFlag        { get; set; }
        public string AgreementFlagM       { get; set; }
        public string EncPersonalNo        { get; set; }
        public string InsureTargetFlag     { get; set; }
        public string OrderItemCode        { get; set; }
        public string OrderItemCodeM       { get; set; }
        public string PickupYMD            { get; set; }
        public string GetYMD               { get; set; }
        public string PurchaseClosingFlag  { get; set; }
        public string PurchaseClosingSeqNo { get; set; }
        public double SupplyAmt            { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public string BillWrite            { get; set; }
        public string InsureFlag           { get; set; }
        public double TransAmt             { get; set; }
        public string ContractFlag         { get; set; }
        
    }

    public class ReqPurchaseInsureList
    {
        public int    CenterCode       { get; set; }
        public int    DateType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarNo            { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string InformationFlag  { get; set; }
        public int    InsureExceptKind { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResPurchaseInsureList
    {
        public List<PurchaseInsureGridModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }
}