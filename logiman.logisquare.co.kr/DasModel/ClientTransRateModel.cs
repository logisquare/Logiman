using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ClientTransRateModel
    {
        public int    SeqNo           { get; set; }
        public int    ClientCode      { get; set; }
        public int    CenterCode      { get; set; }
        public int    ConsignorCode   { get; set; }
        public int    RateType        { get; set; }
        public string FromSido        { get; set; }
        public string FromGugun       { get; set; }
        public string FromDong        { get; set; }
        public string FromAreaCode    { get; set; }
        public string ToSido          { get; set; }
        public string ToGugun         { get; set; }
        public string ToDong          { get; set; }
        public string ToAreaCode      { get; set; }
        public string ToFullAddr      { get; set; }
        public string CarTonCode      { get; set; }
        public string CarTypeCode     { get; set; }
        public int    SaleUnitAmt     { get; set; }
        public int    PurchaseUnitAmt { get; set; }
        public string FromYMD         { get; set; }
        public string ToYMD           { get; set; }
        public string DelFlag         { get; set; }
        public string AdminID         { get; set; }
    }

    public class ReqClientTransRateList
    {
        public int      SeqNo                { get; set; }
        public int      CenterCode           { get; set; }
        public int      ClientCode           { get; set; }
        public string   ClientName           { get; set; }
        public int      ConsignorCode        { get; set; }
        public string   ConsignorName        { get; set; }
        public string   CarTonCode           { get; set; }
        public string   CarTypeCode          { get; set; }
        public int      RateType             { get; set; }
        public string   FromYMD             { get; set; }
        public string   FromFullAddr        { get; set; }
        public string   ToFullAddr          { get; set; }
        public string   DelFlag             { get; set; }
        public string   GradeCode           { get; set; }
        public string   AccessCenterCode    { get; set; }
        public string   AccessCorpNo        { get; set; }
        public int      PageSize            { get; set; }
        public int      PageNo              { get; set; }
        
    }

    public class ResClientTransRateList
    {
        public List<ClientTransRateListViewModel> list      { get; set; }
        public int                                RecordCnt { get; set; }
    }

    public class ClientTransRateListViewModel
    {
        //요율표 항목
        public int    SeqNo           { get; set; }
        public int    CenterCode      { get; set; }
        public string CenterName      { get; set; }
        public int    ClientCode      { get; set; }
        public string ClientName      { get; set; }
        public int    ConsignorCode   { get; set; }
        public string ConsignorName   { get; set; }
        public int    RateType        { get; set; }
        public string RateTypeM       { get; set; }
        public string FromYMD         { get; set; }
        public int    Cnt             { get; set; }
        public string DelFlag         { get; set; }
        public string DelFlagM        { get; set; }
        public string RegAdminID      { get; set; }
        public string RegDate         { get; set; }
        public string UpdAdminID      { get; set; }
        public string UpdDate         { get; set; }
        public string FromSido        { get; set; }
        public string FromGugun       { get; set; }
        public string FromDong        { get; set; }
        public string FromFullAddr    { get; set; }
        public string FromAreaCode    { get; set; }
        public string ToSido          { get; set; }
        public string ToGugun         { get; set; }
        public string ToDong          { get; set; }
        public string ToFullAddr      { get; set; }
        public string ToAreaCode      { get; set; }
        public string CarTonCode      { get; set; }
        public string CarTonCodeM     { get; set; }
        public string CarTypeCode     { get; set; }
        public string CarTypeCodeM    { get; set; }
        public string ToYMD           { get; set; }
        public int    SaleUnitAmt     { get; set; }
        public int    PurchaseUnitAmt { get; set; }
        public string RegYMD          { get; set; }
        public string UpdYMD          { get; set; }
        public string DelAdminID      { get; set; }
        public string DelDate         { get; set; }
        public string ValidationCheck { get; set; }
        public string FromAddrSearch  { get; set; }
        public string ToAddrSearch    { get; set; }
    }
    
    public class ClientTransRateSearchListViewModel
    {
        public string SeqNo           { get; set; }
        public int    CenterCode      { get; set; }
        public string CenterName      { get; set; }
        public string ClientCode      { get; set; }
        public string ClientName      { get; set; }
        public string ConsignorCode   { get; set; }
        public string ConsignorName   { get; set; }
        public int    RateType        { get; set; }
        public string RateTypeM       { get; set; }
        public string FromYMD         { get; set; }
        public string FromSido        { get; set; }
        public string FromGugun       { get; set; }
        public string FromDong        { get; set; }
        public string FromFullAddr    { get; set; }
        public string FromAreaCode    { get; set; }
        public string ToYMD           { get; set; }
        public string ToSido          { get; set; }
        public string ToGugun         { get; set; }
        public string ToDong          { get; set; }
        public string ToFullAddr      { get; set; }
        public string ToAreaCode      { get; set; }
        public string CarTonCode      { get; set; }
        public string CarTonCodeM     { get; set; }
        public string CarTypeCode     { get; set; }
        public string CarTypeCodeM    { get; set; }
        public double SaleUnitAmt     { get; set; }
        public double PurchaseUnitAmt { get; set; }
        public string RegYMD          { get; set; }
        public string RegDate         { get; set; }
        public string RegAdminID      { get; set; }
        public string UpdYMD          { get; set; }
        public string UpdDate         { get; set; }
        public string UpdAdminID      { get; set; }
        public string DelFlag         { get; set; }
        public string DelDate         { get; set; }
        public string DelAdminID      { get; set; }
    }

    public class ReqClientTransRateSearchList
    {
        public int    CenterCode       { get; set; }
        public int    ClientCode       { get; set; }
        public int    ConsignorCode    { get; set; }
        public int    RateType         { get; set; }
        public string FromAddrs        { get; set; }
        public string ToAddrs          { get; set; }
        public string CarTonCode       { get; set; }
        public string CarTypeCode      { get; set; }
        public string ApplyYMD         { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResClientTransRateSearchList
    {
        public List<ClientTransRateSearchListViewModel> list      { get; set; }
        public int                                      RecordCnt { get; set; }
    }

    
}