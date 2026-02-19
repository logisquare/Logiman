using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ReqTransRateList
    {
        public long   ApplySeqNo       { get; set; }
        public long   DtlSeqNo         { get; set; }
        public long   TransSeqNo       { get; set; }
        public int    CenterCode       { get; set; }
        public int    RateRegKind      { get; set; }
        public int    RateType         { get; set; }
        public string FTLFlag          { get; set; }
        public string TransRateName    { get; set; }
        public int    GoodsRunType     { get; set; }
        public string FromFullAddr     { get; set; }
        public string ToFullAddr       { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResTransRateList
    {
        public List<TransRateList> list      { get; set; }
        public int                 RecordCnt { get; set; }
    }

    public class TransRateList
    {
        public string TransSeqNo       { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public int    RateRegKind      { get; set; }
        public string RateRegKindM     { get; set; }
        public int    RateType         { get; set; }
        public string RateTypeM        { get; set; }
        public string FTLFlag          { get; set; }
        public string FTLFlagM         { get; set; }
        public string TransRateName    { get; set; }
        public int    TransRateCnt     { get; set; }
        public int    ClientApplyCnt   { get; set; }
        public int    RateApplyCnt     { get; set; }
        public double ExpectProfitRate { get; set; }
        public string RegYMD           { get; set; }
        public string RegDate          { get; set; }
        public string RegAdminID       { get; set; }
        public string RegAdminName     { get; set; }
        public string UpdYMD           { get; set; }
        public string UpdDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
        public string DelFlag          { get; set; }
        public string DelFlagM         { get; set; }
        public string DelDate          { get; set; }
        public string DelAdminID       { get; set; }
        public string DelAdminName     { get; set; }
    }

    public class ResTransRateApplyClientList
    {
        public List<TransRateApplyClientList> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class TransRateApplyClientList
    {
        public string ApplySeqNo         { get; set; }
        public int    ClientCode         { get; set; }
        public string ClientName         { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public int    ConsignorCode      { get; set; }
        public string ConsignorName      { get; set; }
        public string OrderItemCode      { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderLocationCode  { get; set; }
        public string OrderLocationCodeM { get; set; }
        public int    RateRegKind        { get; set; }
        public string UpdType            { get; set; }
    }

    public class TransRateModel
    {
        public long   TransSeqNo              { get; set; }
        public long   ApplySeqNo              { get; set; }
        public int    CenterCode              { get; set; }
        public int    RateRegKind             { get; set; }
        public int    RateType                { get; set; }
        public string FTLFlag                 { get; set; }
        public string TransRateName           { get; set; }
        public int    GoodsRunType            { get; set; }
        public string FromSido                { get; set; }
        public string FromGugun               { get; set; }
        public string FromDong                { get; set; }
        public string FromAreaCode            { get; set; }
        public string ToSido                  { get; set; }
        public string ToGugun                 { get; set; }
        public string ToDong                  { get; set; }
        public string ToAreaCode              { get; set; }
        public string CarTonCode              { get; set; }
        public string CarTypeCode             { get; set; }
        public double TypeValueFrom           { get; set; }
        public double TypeValueTo             { get; set; }
        public double SaleUnitAmt             { get; set; }
        public double PurchaseUnitAmt         { get; set; }
        public double FixedPurchaseUnitAmt    { get; set; }
        public double ExtSaleUnitAmt          { get; set; }
        public double ExtPurchaseUnitAmt      { get; set; }
        public double ExtFixedPurchaseUnitAmt { get; set; }
        public string RegAdminID              { get; set; }
        public string UpdAdminID              { get; set; }
        public string DelFlag                 { get; set; }
        public int    UpdType                 { get; set; }
        public long   OutTransSeqNo           { get; set; }
        public long   DtlSeqNo                { get; set; }
        public long   OutApplySeqNo           { get; set; }
        public string Exists                  { get; set; }
        public long   ClientCode              { get; set; }
        public long   ConsignorCode           { get; set; }
        public string OrderItemCode           { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string RegOrderLocationCodes   { get; set; }
    }

    public class ResTransRateDtlList
    {
        public List<TransRateDtlList> list      { get; set; }
        public int                    RecordCnt { get; set; }
    }

    public class TransRateDtlList
    {
        public string DtlSeqNo                   { get; set; }
        public string TransSeqNo                 { get; set; }
        public int    CenterCode                 { get; set; }
        public int    RateRegKind                { get; set; }
        public string RateRegKindM               { get; set; }
        public int    RateType                   { get; set; }
        public string RateTypeM                  { get; set; }
        public string TransRateFTLFlag           { get; set; }
        public string FTLFlag                    { get; set; }
        public string FTLFlagM                   { get; set; }
        public int    GoodsRunType               { get; set; }
        public string GoodsRunTypeM              { get; set; }
        public string TransRateName              { get; set; }
        public string FromSido                   { get; set; }
        public string FromGugun                  { get; set; }
        public string FromDong                   { get; set; }
        public string FromFullAddr               { get; set; }
        public string FromAreaCode               { get; set; }
        public string ToSido                     { get; set; }
        public string ToGugun                    { get; set; }
        public string ToDong                     { get; set; }
        public string ToFullAddr                 { get; set; }
        public string ToAreaCode                 { get; set; }
        public string CarTonCode                 { get; set; }
        public string CarTonCodeM                { get; set; }
        public string CarTypeCode                { get; set; }
        public string CarTypeCodeM               { get; set; }
        public double TypeValueFrom              { get; set; }
        public double TypeValueTo                { get; set; }
        public double NewTypeValueFrom           { get; set; }
        public double NewTypeValueTo             { get; set; }
        public double SaleUnitAmt                { get; set; }
        public double PurchaseUnitAmt            { get; set; }
        public double FixedPurchaseUnitAmt       { get; set; }
        public double ExtSaleUnitAmt             { get; set; }
        public double ExtPurchaseUnitAmt         { get; set; }
        public double ExtFixedPurchaseUnitAmt    { get; set; }
        public double NewSaleUnitAmt             { get; set; }
        public double NewPurchaseUnitAmt         { get; set; }
        public double NewFixedPurchaseUnitAmt    { get; set; }
        public double NewExtSaleUnitAmt          { get; set; }
        public double NewExtPurchaseUnitAmt      { get; set; }
        public double NewExtFixedPurchaseUnitAmt { get; set; }
        public string RegAdminID                 { get; set; }
        public string RegAdminName               { get; set; }
        public string RegYMD                     { get; set; }
        public string RegDate                    { get; set; }
        public string UpdAdminID                 { get; set; }
        public string UpdAdminName               { get; set; }
        public string UpdYMD                     { get; set; }
        public string UpdDate                    { get; set; }
        public string DelFlag                    { get; set; }
        public string DelFlagM                   { get; set; }
        public string DelAdminID                 { get; set; }
        public string DelAdminName               { get; set; }
        public string DelDate                    { get; set; }
        public string ValidationCheck            { get; set; }
    }

    public class ReqTransRateApplyList
    {
        public long   ApplySeqNo        { get; set; }
        public long   ClientCode        { get; set; }
        public string ClientName        { get; set; }
        public int    CenterCode        { get; set; }
        public long   ConsignorCode     { get; set; }
        public string ConsignorName     { get; set; }
        public string OrderItemCode     { get; set; }
        public string OrderLocationCode { get; set; }
        public string DelFlag           { get; set; }
        public string AccessCenterCode  { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }
    }

    public class ResTransRateApplyList
    {
        public List<TransRateApplyList> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class TransRateApplyList
    {
        public string ApplySeqNo               { get; set; }
        public string ClientCode               { get; set; }
        public string ClientName               { get; set; }
        public string ClientCorpNo             { get; set; }
        public int    CenterCode               { get; set; }
        public string CenterName               { get; set; }
        public string ConsignorCode            { get; set; }
        public string ConsignorName            { get; set; }
        public string OrderItemCode            { get; set; }
        public string OrderItemCodeM           { get; set; }
        public string OrderLocationCodes       { get; set; }
        public string OrderLocationCodesM      { get; set; }
        public string FtlSPTransSeqNo          { get; set; }
        public string FtlSPTransSeqNoM         { get; set; }
        public string FtlSTransSeqNo           { get; set; }
        public string FtlSTransSeqNoM          { get; set; }
        public string FtlPTransSeqNo           { get; set; }
        public string FtlPTransSeqNoM          { get; set; }
        public string FtlYN                    { get; set; }
        public string FtlPRateFlag             { get; set; }
        public string FtlPurchaseRate          { get; set; }
        public string FtlFixedPurchaseRate     { get; set; }
        public int    FtlRoundAmtKind          { get; set; }
        public string FtlRoundAmtKindM         { get; set; }
        public string FtlRoundType             { get; set; }
        public string FtlRoundTypeM            { get; set; }
        public double FtlExpectProfitRate      { get; set; }
        public string LtlSPTransSeqNo          { get; set; }
        public string LtlSPTransSeqNoM         { get; set; }
        public string LtlSTransSeqNo           { get; set; }
        public string LtlSTransSeqNoM          { get; set; }
        public string LtlPTransSeqNo           { get; set; }
        public string LtlPTransSeqNoM          { get; set; }
        public string LtlYN                    { get; set; }
        public string LtlPRateFlag             { get; set; }
        public double LtlPurchaseRate          { get; set; }
        public double LtlFixedPurchaseRate     { get; set; }
        public int    LtlRoundAmtKind          { get; set; }
        public string LtlRoundAmtKindM         { get; set; }
        public string LtlRoundType             { get; set; }
        public string LtlRoundTypeM            { get; set; }
        public double LtlExpectProfitRate      { get; set; }
        public string LayoverTransSeqNo        { get; set; }
        public string LayoverTransSeqNoM       { get; set; }
        public string LayoverYN                { get; set; }
        public string OilTransSeqNo            { get; set; }
        public string OilTransSeqNoM           { get; set; }
        public string OilYN                    { get; set; }
        public string OilPeriodType            { get; set; }
        public string OilPeriodTypeM           { get; set; }
        public string OilSearchArea            { get; set; }
        public string OilPrice                 { get; set; }
        public string OilGetPlace1             { get; set; }
        public string OilGetPlace2             { get; set; }
        public string OilGetPlace3             { get; set; }
        public string OilGetPlace4             { get; set; }
        public string OilGetPlace5             { get; set; }
        public int    OilSaleRoundAmtKind      { get; set; }
        public string OilSaleRoundType         { get; set; }
        public int    OilPurchaseRoundAmtKind  { get; set; }
        public string OilPurchaseRoundType     { get; set; }
        public int    OilFixedRoundAmtKind     { get; set; }
        public string OilFixedRoundType        { get; set; }
        public string OilSaleRoundAmtKindM     { get; set; }
        public string OilSaleRoundTypeM        { get; set; }
        public string OilPurchaseRoundAmtKindM { get; set; }
        public string OilPurchaseRoundTypeM    { get; set; }
        public string OilFixedRoundAmtKindM    { get; set; }
        public string OilFixedRoundTypeM       { get; set; }
        public string RegAdminID               { get; set; }
        public string RegAdminName             { get; set; }
        public string RegYMD                   { get; set; }
        public string RegDate                  { get; set; }
        public string UpdAdminID               { get; set; }
        public string UpdAdminName             { get; set; }
        public string UpdYMD                   { get; set; }
        public string UpdDate                  { get; set; }
        public string DelFlag                  { get; set; }
        public string DelAdminID               { get; set; }
        public string DelAdminName             { get; set; }
        public string DelDate                  { get; set; }
        public string RegOrderLocationCodes    { get; set; }
    }

    public class TransRateOilModel
    {
        public string StdYMD       { get; set; }
        public int    OilPriceType { get; set; }
        public int    OilType      { get; set; }
        public int    AvgType      { get; set; }
        public string Sido         { get; set; }
        public double AvgPrice     { get; set; }
    }

    public class TransRateApplyModel
    {
        public long   ClientCode              { get; set; }
        public int    CenterCode              { get; set; }
        public long   ConsignorCode           { get; set; }
        public string OrderItemCode           { get; set; }
        public string OrderLocationCodes      { get; set; }
        public long   FtlSPTransSeqNo         { get; set; }
        public long   FtlSTransSeqNo          { get; set; }
        public long   FtlPTransSeqNo          { get; set; }
        public string FtlPRateFlag            { get; set; }
        public double FtlPurchaseRate         { get; set; }
        public double FtlFixedPurchaseRate    { get; set; }
        public int    FtlRoundAmtKind         { get; set; }
        public string FtlRoundType            { get; set; }
        public long   LtlSPTransSeqNo         { get; set; }
        public long   LtlSTransSeqNo          { get; set; }
        public long   LtlPTransSeqNo          { get; set; }
        public string LtlPRateFlag            { get; set; }
        public double LtlPurchaseRate         { get; set; }
        public double LtlFixedPurchaseRate    { get; set; }
        public int    LtlRoundAmtKind         { get; set; }
        public string LtlRoundType            { get; set; }
        public long   LayoverTransSeqNo       { get; set; }
        public long   OilTransSeqNo           { get; set; }
        public int    OilPeriodType           { get; set; }
        public string OilSearchArea           { get; set; }
        public double OilPrice                { get; set; }
        public string OilGetPlace1            { get; set; }
        public string OilGetPlace2            { get; set; }
        public string OilGetPlace3            { get; set; }
        public string OilGetPlace4            { get; set; }
        public string OilGetPlace5            { get; set; }
        public int    OilSaleRoundAmtKind     { get; set; }
        public string OilSaleRoundType        { get; set; }
        public int    OilPurchaseRoundAmtKind { get; set; }
        public string OilPurchaseRoundType    { get; set; }
        public int    OilFixedRoundAmtKind    { get; set; }
        public string OilFixedRoundType       { get; set; }
        public string RegAdminID              { get; set; }
        public long   ApplySeqNo              { get; set; }
        public string DelFlag                 { get; set; }
    }
}