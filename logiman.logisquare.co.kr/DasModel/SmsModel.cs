using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class SmsBillModel
    {
        public int    CenterCode           { get; set; }
        public long   PurchaseClosingSeqNo { get; set; }
        public string ComCorpNo            { get; set; }
        public string DriverName           { get; set; }
        public string DriverCell           { get; set; }
        public string TimeStamp            { get; set; }
        public string CorpNoChkPassFlag    { get; set; }

        public SmsBillModel()
        {
            CorpNoChkPassFlag = "Y";
        }
    }

    public class SmsPayModel
    {
        public int    CenterCode           { get; set; }
        public long   PurchaseClosingSeqNo { get; set; }
        public string ComCorpNo            { get; set; }
        public string DriverName           { get; set; }
        public string DriverCell           { get; set; }
        public string ComCorpNoChkFlag     { get; set; }
        public string TimeStamp            { get; set; }
        public string CorpNoChkPassFlag    { get; set; }

        public SmsPayModel()
        {
            ComCorpNoChkFlag  = "N";
            CorpNoChkPassFlag = "N";
        }
    }

    public class SmsPurchaseClosingGridModel
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
        public double SendAmt              { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string BillWrite            { get; set; }
        public string BillLimitYMD         { get; set; }
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
        public string ComCloseYMD          { get; set; }
        public string ComUpdYMD            { get; set; }
        public int    ComTaxKind           { get; set; }
        public string ComTaxKindM          { get; set; }
        public string ComTaxMsg            { get; set; }
        public string CardAgreeFlag        { get; set; }
        public string CardAgreeYMD         { get; set; }
        public string BankCode             { get; set; }
        public string BankName             { get; set; }
        public string EncAcctNo            { get; set; }
        public string SearchAcctNo         { get; set; }
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
        public double TransCost            { get; set; }
        public double InsureRateAmt        { get; set; }
        public double InsureReduceAmt      { get; set; }
        public double DriverInsureAmt      { get; set; }
        public double NotiDriverInsureAmt  { get; set; }
        public double CenterInsureAmt      { get; set; }
        public double NotiCenterInsureAmt  { get; set; }
        public double InputDeductAmt       { get; set; }
        public string InsureFlag           { get; set; }
    }


    public class ReqSmsPurchaseClosingList
    {
        public long   PurchaseClosingSeqNo  { get; set; }
        public int    CenterCode            { get; set; }
        public int    DateType              { get; set; }
        public string DateFrom              { get; set; }
        public string DateTo                { get; set; }
        public string ComCorpNo             { get; set; }
        public int    PageSize              { get; set; }
        public int    PageNo                { get; set; }
    }

    public class ResSmsPurchaseClosingList
    {
        public List<SmsPurchaseClosingGridModel> list      { get; set; }
        public int                               RecordCnt { get; set; }
    }

    public class SmsInsureModel
    {
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public long   DriverSeqNo      { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string TimeStamp        { get; set; }
        public string ChkPassFlag      { get; set; }
        public string ChkCertFlag      { get; set; }
        public string ChkCertTimeStamp { get; set; }
        public string AuthName         { get; set; }
        public string CI               { get; set; }
        public string DI               { get; set; }
        public string BirthDay         { get; set; }
        public string SexCode          { get; set; }

        public SmsInsureModel()
        {
            ChkPassFlag = "Y";
            ChkCertFlag = "N";
        }
    }
    
    public class SmsSafetyModel
    {
        public int    CenterCode    { get; set; }
        public long   OrderNo       { get; set; }
        public long   DispatchSeqNo { get; set; }
        public long   RefSeqNo      { get; set; }
        public string DriverName    { get; set; }
        public long   SeqNo         { get; set; }
        public string YMD           { get; set; }
        public string TimeStamp     { get; set; }
    }

    public class ReqSafetyCheckReplayUpd
    {
        public int  CenterCode    { get; set; }
        public long OrderNo       { get; set; }
        public long DispatchSeqNo { get; set; }
        public long RefSeqNo      { get; set; }
        public long SeqNo         { get; set; }
    }

    public class ReqEventAvailChk
    {
        public string CorpNo { get; set; }
    }

    public class ResEventAvailChk
    {
        public string EventAvailFlag { get; set; }
    }
}