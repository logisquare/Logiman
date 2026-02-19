using System;
using System.Collections.Generic;

namespace CommonLibrary.DasServices
{

    public class ReqAppCarDispatchList
    {
        public long   RefSeqNo           { get; set; }
        public long   CarSeqNo           { get; set; }
        public int    CenterCode         { get; set; }
        public long   DriverSeqNo        { get; set; }
        public string DriverCell         { get; set; }
        public string DriverName         { get; set; }
        public long   ComCode            { get; set; }
        public int    ContractCenterCode { get; set; }
        public string ComTypeCode        { get; set; }
        public string ComCorpNo          { get; set; }
        public string ComName            { get; set; }
        public string ComCeoName         { get; set; }
        public string CarComName         { get; set; }
        public string CarNo              { get; set; }
        public string SearchCarNo        { get; set; }
        public string CarTypeCode        { get; set; }
        public int    CarDivType         { get; set; }
        public string CarTonCode         { get; set; }
        public string CarBrandCode       { get; set; }
        public string CarNote            { get; set; }
        public string CooperatorFlag     { get; set; }
        public string CargoManFlag       { get; set; }

        public string   AcctName                { get; set; }
        public string   SearchAcctNo            { get; set; }
        public string   UseFlag                 { get; set; }
        public int      GradeCode               { get; set; }
        public string   AccessCenterCode        { get; set; }
        public string   AccessCorpNo            { get; set; }
        public string   FromYmd                 { get; set; }
        public string   ToYmd                   { get; set; }
        public string   UseYmd                  { get; set; }
        public int      PageSize                { get; set; }
        public int      PageNo                  { get; set; }
        
    }

    public class ResAppCarDispatchList
    {
        public List<AppCarDispatchListViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class AppCarDispatchViewModel
    {
        public long   RefSeqNo           { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public int    CarDivType         { get; set; }
        public long   CarSeqNo           { get; set; }
        public string CarNo              { get; set; }
        public string CarTypeCode        { get; set; }
        public string CarSubType         { get; set; }
        public string CarTonCode         { get; set; }
        public string CarBrandCode       { get; set; }
        public string CarNote            { get; set; }
        public long   ComCode            { get; set; }
        public int    ContractCenterCode { get; set; }
        public string ComTypeCode        { get; set; }
        public string ComName            { get; set; }
        public string ComCeoName         { get; set; }
        public string ComCorpNo          { get; set; }
        public string ComBizType         { get; set; }
        public string ComBizClass        { get; set; }
        public string ComTelNo           { get; set; }
        public string ComFaxNo           { get; set; }
        public string ComEmail           { get; set; }
        public string ComPost            { get; set; }
        public string ComAddr            { get; set; }
        public string ComAddrDtl         { get; set; }
        public int    ComStatus          { get; set; }
        public int    ComTaxKind         { get; set; }
        public string ComTaxMsg          { get; set; }
        public string CardAgreeFlag      { get; set; }
        public string CardAgreeYMD       { get; set; }
        public long   DriverSeqNo        { get; set; }
        public string DriverName         { get; set; }
        public string DriverCell         { get; set; }
        public int    PayDay             { get; set; }
        public string BankCode           { get; set; }
        public string EncAcctNo          { get; set; }
        public string SearchAcctNo       { get; set; }
        public string AcctName           { get; set; }
        public string AcctValidFlag      { get; set; }
        public string CooperatorFlag     { get; set; }
        public string ChargeName         { get; set; }
        public string ChargeTelNo        { get; set; }
        public string ChargeEmail        { get; set; }
        public string RefNote            { get; set; }
        public int    DtlSeqNo           { get; set; }
        public string CargoManFlag       { get; set; }
        public string UseFlag            { get; set; }
        public string AdminID            { get; set; }
    }

    public class AppCarDispatchListViewModel
    {
        public string RefSeqNo         { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public int    CarDivType       { get; set; }
        public string CarDivTypeM      { get; set; }
        public string RefNote          { get; set; }
        public string RefUseFlag       { get; set; }
        public long   ComCode          { get; set; }
        public string ComTypeCode      { get; set; }
        public string ComTypeCodeM     { get; set; }
        public string ComName          { get; set; }
        public string ComCeoName       { get; set; }
        public string ComCorpNo        { get; set; }
        public string ComBizType       { get; set; }
        public string ComBizClass      { get; set; }
        public string ComTelNo         { get; set; }
        public string ComFaxNo         { get; set; }
        public string ComEmail         { get; set; }
        public string ComPost          { get; set; }
        public string ComAddr          { get; set; }
        public string ComAddrDtl       { get; set; }
        public int    ComStatus        { get; set; }
        public string ComStatusM       { get; set; }
        public string ComCloseYMD      { get; set; }
        public string ComUpdYMD        { get; set; }
        public int    ComTaxKind       { get; set; }
        public string ComTaxKindM      { get; set; }
        public string ComTaxMsg        { get; set; }
        public string CardAgreeFlag    { get; set; }
        public string CardAgreeYMD     { get; set; }
        public int    DtlSeqNo         { get; set; }
        public int    PayDay           { get; set; }
        public string BankCode         { get; set; }
        public string BankName         { get; set; }
        public string EncAcctNo        { get; set; }
        public string SearchAcctNo     { get; set; }
        public string AcctName         { get; set; }
        public string AcctValidFlag    { get; set; }
        public string CooperatorFlag   { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeEmail      { get; set; }
        public long   CarSeqNo         { get; set; }
        public string CarNo            { get; set; }
        public string CarTypeCode      { get; set; }
        public string CarTypeCodeM     { get; set; }
        public string CarSubType       { get; set; }
        public string CarTonCode       { get; set; }
        public string CarTonCodeM      { get; set; }
        public string CarBrandCode     { get; set; }
        public string CarBrandCodeM    { get; set; }
        public string CarNote          { get; set; }
        public long   DriverSeqNo      { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string InsureTargetFlag { get; set; }
        public string InformationFlag  { get; set; }
        public string InformationDate  { get; set; }
        public string InformationFlagM { get; set; }
        public string AgreementFlag    { get; set; }
        public string AgreementDate    { get; set; }
        public string AgreementFlagM   { get; set; }
        public string CargoManFlag     { get; set; }
        public string UseFlag          { get; set; }
        public string RegAdminID       { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdDate          { get; set; }
        public int    CarTotalCnt      { get; set; }

    }


    public class AppCarModel
    {
        public string CarSeqNo           { get; set; }
        public string CarNo              { get; set; }
        public string SearchCarNo        { get; set; }
        public string CarTypeCode        { get; set; }
        public string CarTypeCodeM       { get; set; }
        public string CarSubType         { get; set; }
        public string CarTonCode         { get; set; }
        public string CarTonCodeM        { get; set; }
        public string CarBrandCode       { get; set; }
        public string CarBrandCodeM      { get; set; }
        public string CarNote            { get; set; }
        public string CarInfo            { get; set; }
        public string UseFlag            { get; set; }
        public string RegAdminID         { get; set; }
        public string RegDate            { get; set; }
        public string UpdAdminID         { get; set; }
        public string UpdDate            { get; set; }
        public string CenterContractFlag { get; set; }
        public string ComKindM           { get; set; }
    }

    public class ReqAppCarSearchList
    {
        public string CarNo       { get; set; }
        public string SearchCarNo { get; set; }
        public string UseFlag     { get; set; }
        public int    PageSize    { get; set; }
        public int    PageNo      { get; set; }
    }

    public class ResAppCarSearchList
    {
        public List<AppCarModel> list      { get; set; }
        public int            RecordCnt { get; set; }
    }

    public class AppCarDriverModel
    {
        public string DriverSeqNo { get; set; }
        public string DriverName  { get; set; }
        public string DriverCell  { get; set; }
        public string DriverInfo  { get; set; }
        public string UseFlag     { get; set; }
        public string UseFlagM    { get; set; }
        public string RegAdminID  { get; set; }
        public string RegDate     { get; set; }
        public string UpdAdminID  { get; set; }
        public string UpdDate     { get; set; }
    }

    public class ReqAppCarDriverSearchList
    {
        public string DriverName { get; set; }
        public string DriverCell { get; set; }
        public string UseFlag    { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }
    }

    public class ResAppCarDriverSearchList
    {
        public List<AppCarDriverModel> list      { get; set; }
        public int               RecordCnt { get; set; }
    }

    public class AppCarCompanyModel
    {
        public string ComCode       { get; set; }
        public string ComName       { get; set; }
        public string ComCeoName    { get; set; }
        public string ComCorpNo     { get; set; }
        public string ComBizType    { get; set; }
        public string ComBizClass   { get; set; }
        public string ComTelNo      { get; set; }
        public string ComFaxNo      { get; set; }
        public string ComEmail      { get; set; }
        public string ComPost       { get; set; }
        public string ComAddr       { get; set; }
        public string ComAddrDtl    { get; set; }
        public int    ComStatus     { get; set; }
        public string ComStatusM    { get; set; }
        public string ComCloseYMD   { get; set; }
        public string ComUpdYMD     { get; set; }
        public int    ComTaxKind    { get; set; }
        public string ComTaxKindM   { get; set; }
        public string ComTaxMsg     { get; set; }
        public string CardAgreeFlag { get; set; }
        public string CardAgreeYMD  { get; set; }
        public string ComInfo       { get; set; }
        public string UseFlag       { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdDate       { get; set; }

    }

    public class ReqAppCarCompanySearchList
    {
        public string ComName    { get; set; }
        public string ComCeoName { get; set; }
        public string ComCorpNo  { get; set; }
        public string UseFlag    { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }
    }

    public class ResAppCarCompanySearchList
    {
        public List<AppCarCompanyModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class AppCarDispatchRefModel
    {
        public string RefSeqNo       { get; set; }
        public int    CenterCode     { get; set; }
        public string CenterName     { get; set; }
        public string CarDivType     { get; set; }
        public string CarDivTypeM    { get; set; }
        public string RefNote        { get; set; }
        public string CargoManFlag   { get; set; }
        public string RefUseFlag     { get; set; }
        public string ComCode        { get; set; }
        public string ComName        { get; set; }
        public string ComCeoName     { get; set; }
        public string ComCorpNo      { get; set; }
        public string ComBizType     { get; set; }
        public string ComBizClass    { get; set; }
        public string ComTelNo       { get; set; }
        public string ComFaxNo       { get; set; }
        public string ComEmail       { get; set; }
        public string ComPost        { get; set; }
        public string ComAddr        { get; set; }
        public string ComAddrDtl     { get; set; }
        public int    ComStatus      { get; set; }
        public string ComStatusM     { get; set; }
        public string ComCloseYMD    { get; set; }
        public string ComUpdYMD      { get; set; }
        public int    ComTaxKind     { get; set; }
        public string ComTaxKindM    { get; set; }
        public string ComTaxMsg      { get; set; }
        public string CardAgreeFlag  { get; set; }
        public string CardAgreeYMD   { get; set; }
        public int    DtlSeqNo       { get; set; }
        public string PayDay         { get; set; }
        public string BankCode       { get; set; }
        public string BankName       { get; set; }
        public string EncAcctNo      { get; set; }
        public string SearchAcctNo   { get; set; }
        public string AcctName       { get; set; }
        public string AcctValidFlag  { get; set; }
        public string CooperatorFlag { get; set; }
        public string ChargeName     { get; set; }
        public string ChargeTelNo    { get; set; }
        public string ChargeEmail    { get; set; }
        public string CarSeqNo       { get; set; }
        public string CarNo          { get; set; }
        public string CarTypeCode    { get; set; }
        public string CarTypeCodeM   { get; set; }
        public string CarSubType     { get; set; }
        public string CarTonCode     { get; set; }
        public string CarTonCodeM    { get; set; }
        public string CarBrandCode   { get; set; }
        public string CarBrandCodeM  { get; set; }
        public string CarNote        { get; set; }
        public string DriverSeqNo    { get; set; }
        public string DriverName     { get; set; }
        public string DriverCell     { get; set; }
        public string ComInfo        { get; set; }
        public string CarInfo        { get; set; }
        public string DriverInfo     { get; set; }
        public string DispatchInfo   { get; set; }
        public string UseFlag        { get; set; }
        public string RegAdminID     { get; set; }
        public string RegDate        { get; set; }
        public string UpdAdminID     { get; set; }
        public string UpdDate        { get; set; }

    }

    public class ReqAppCarDispatchRefSearchList
    {
        public int    CenterCode       { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string ComName          { get; set; }
        //public string CarComName       { get; set; }
        public string ComCeoName       { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarNo            { get; set; }
        public string SearchCarNo      { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public string UseFlag          { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResAppCarDispatchRefSearchList
    {
        public List<AppCarDispatchRefModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class ReqAppCarCompanyAcctUpd
    {
        public int    CenterCode    { get; set; }
        public long   ComCode       { get; set; }
        public string ComCorpNo     { get; set; }
        public string DriverCell    { get; set; }
        public int    ReqType       { get; set; }
        public string BankCode      { get; set; }
        public string EncAcctNo     { get; set; }
        public string SearchAcctNo  { get; set; }
        public string AcctName      { get; set; }
        public string AcctValidFlag { get; set; }
        public string AdminID       { get; set; }
    }
}