using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ClientModel
    {
        public int    ClientCode            { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public int    CenterType            { get; set; }
        public string ClientType            { get; set; }
        public string ClientTypeM           { get; set; }
        public string ClientName            { get; set; }
        public string ClientCeoName         { get; set; }
        public string ClientCorpNo          { get; set; }
        public string ClientBizType         { get; set; }
        public string ClientBizClass        { get; set; }
        public string ClientTelNo           { get; set; }
        public string ClientFaxNo           { get; set; }
        public string ClientEmail           { get; set; }
        public string ClientPost            { get; set; }
        public string ClientAddr            { get; set; }
        public string ClientAddrDtl         { get; set; }
        public int    ClientStatus          { get; set; }
        public string ClientStatusM         { get; set; }
        public string ClientCloseYMD        { get; set; }
        public string ClientUpdYMD          { get; set; }
        public int    ClientTaxKind         { get; set; }
        public string ClientTaxKindM        { get; set; }
        public string ClientTaxMsg          { get; set; }
        public string ClientCheckYMD        { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public string ClientPayDay          { get; set; }
        public string ClientPayDayM         { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public string ClientDMPost          { get; set; }
        public string ClientDMAddr          { get; set; }
        public string ClientDMAddrDtl       { get; set; }
        public string ClientFPISFlag        { get; set; }
        public string ClientBankCode        { get; set; }
        public string ClientBankName        { get; set; }
        public string ClientEncAcctNo       { get; set; }
        public string ClientSearchAcctNo    { get; set; }
        public string ClientAcctNo          { get; set; }
        public string ClientAcctName        { get; set; }
        public int    TransCenterCode       { get; set; }
        public string TransCenterName       { get; set; }
        public string ClientNote1           { get; set; }
        public string ClientNote2           { get; set; }
        public string ClientNote3           { get; set; }
        public string ClientNote4           { get; set; }
        public double SaleLimitAmt          { get; set; }
        public double RevenueLimitPer       { get; set; }
        public string ClientInfo            { get; set; }
        public string DouzoneCode           { get; set; }
        public string UseFlag               { get; set; }
        public string RegAdminID            { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdDate               { get; set; }
    }

    public class ReqClientList
    {
        public int    ClientCode          { get; set; }
        public int    CenterCode          { get; set; }
        public string ClientType          { get; set; }
        public string ClientName          { get; set; }
        public string ClientCeoName       { get; set; }
        public string ClientCorpNo        { get; set; }
        public string SaleLimitAmtFlag    { get; set; }
        public string RevenueLimitPerFlag { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResClientList
    {
        public List<ClientModel> list      { get; set; }
        public int                  RecordCnt { get; set; }
    }


    public class ClientChargeModel
    {
        public int    ChargeSeqNo      { get; set; }
        public int    ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeCell       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeTelExtNo   { get; set; }
        public string ChargeFaxNo      { get; set; }
        public string ChargeEmail      { get; set; }
        public string ChargePosition   { get; set; }
        public string ChargeDepartment { get; set; }
        public string ChargeLocation   { get; set; }
        public string OrderFlag        { get; set; }
        public string PayFlag          { get; set; }
        public string ArrivalFlag      { get; set; }
        public string BillFlag         { get; set; }
        public string UseFlag          { get; set; }
        public string RegAdminID       { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdDate          { get; set; }

    }

    public class ReqClientChargeList
    {
        public int    ChargeSeqNo      { get; set; }
        public int    ClientCode       { get; set; }
        public int    CenterCode       { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeCell       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string OrderFlag        { get; set; }
        public string PayFlag          { get; set; }
        public string ArrivalFlag      { get; set; }
        public string BillFlag         { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResClientChargeList
    {
        public List<ClientChargeModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class ClientConsignorModel
    {
        public string EncSeqNo      { get; set; }
        public int    SeqNo         { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public int    ClientCode    { get; set; }
        public string ClientName    { get; set; }
        public string ClientCeoName { get; set; }
        public string ClientCorpNo  { get; set; }
        public int    ConsignorCode { get; set; }
        public string ConsignorName { get; set; }
        public string ConsignorNote { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string DelFlag       { get; set; }
        public string DelAdminID    { get; set; }
        public string DelDate       { get; set; }
    }

    public class ReqClientConsignorList
    {
        public int    SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public int    ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public int    ConsignorCode    { get; set; }
        public string ConsignorName    { get; set; }
        public string AccessCenterCode { get; set; }
        public string DelFlag          { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResClientConsignorList
    {
        public List<ClientConsignorModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }


    public class ClientSearchModel
    {

        public int    SeqNo                 { get; set; }
        public int    ClientCode            { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public int    CenterType            { get; set; }
        public string ClientType            { get; set; }
        public string ClientTypeM           { get; set; }
        public string ClientName            { get; set; }
        public string ClientCeoName         { get; set; }
        public string ClientCorpNo          { get; set; }
        public string ClientBizType         { get; set; }
        public string ClientBizClass        { get; set; }
        public string ClientTelNo           { get; set; }
        public int    ClientStatus          { get; set; }
        public string ClientStatusM         { get; set; }
        public int    ClientTaxKind         { get; set; }
        public string ClientTaxKindM        { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public string ClientInfo            { get; set; }
        public double SaleLimitAmt          { get; set; }
        public double RevenueLimitPer       { get; set; }
        public string MisuFlag              { get; set; }
        public double TotalMisuAmt          { get; set; }
        public double MisuAmt               { get; set; }
        public int    NoMatchingCnt         { get; set; }
        public string UseFlag               { get; set; }
        public string RegAdminID            { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdDate               { get; set; }
        public int    ChargeSeqNo           { get; set; }
        public string ChargeName            { get; set; }
        public string ChargeCell            { get; set; }
        public string ChargeTelNo           { get; set; }
        public string ChargeTelExtNo        { get; set; }
        public string ChargePosition        { get; set; }
        public string ChargeDepartment      { get; set; }
        public string ChargeLocation        { get; set; }
        public string ChargeEmail           { get; set; }
        public string ChargeOrderFlag       { get; set; }
        public string ChargePayFlag         { get; set; }
        public string ChargeArrivalFlag     { get; set; }
        public string ChargeBillFlag        { get; set; }
        public string ChargeUseFlag         { get; set; }
        public string ChargeInfo            { get; set; }
    }

    public class ReqClientSearchList
    {
        public int    ClientCode        { get; set; }
        public int    CenterCode        { get; set; }
        public string ClientType        { get; set; }
        public string ClientName        { get; set; }
        public string ClientCeoName     { get; set; }
        public string ClientCorpNo      { get; set; }
        public string UseFlag           { get; set; }
        public string ChargeName        { get; set; }
        public string ChargeOrderFlag   { get; set; }
        public string ChargePayFlag     { get; set; }
        public string ChargeArrivalFlag { get; set; }
        public string ChargeBillFlag    { get; set; }
        public string ChargeUseFlag     { get; set; }
        public string ClientFlag        { get; set; }
        public string ChargeFlag        { get; set; }
        public string AccessCenterCode  { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }
    }

    public class ResClientSearchList
    {
        public List<ClientSearchModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class ReqClientNoteUpd
    {
        public int    CenterCode    { get; set; }
        public long   ClientCode    { get; set; }
        public long   ConsignorCode { get; set; }
        public int    Type          { get; set; }
        public string Note          { get; set; }
        public string AdminID       { get; set; }
    }

    public class ReqClientMisuUpd
    {
        public int    CenterCode    { get; set; }
        public long   ClientCode    { get; set; }
        public string AdminID       { get; set; }
    }

    public class ResClientMisuUpd
    {
        public string MisuFlag      { get; set; }
        public double TotalMisuAmt  { get; set; }
        public double MisuAmt       { get; set; }
        public int    NoMatchingCnt { get; set; }
    }
}