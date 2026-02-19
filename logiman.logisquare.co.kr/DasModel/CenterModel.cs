using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ReqCenterList
    {
        public int    CenterCode { get; set; }
        public int    CenterType { get; set; }
        public string CorpNo     { get; set; }
        public string CenterName { get; set; }
        public string AdminID    { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }
    }

    public class ResCenterList
    {
        public List<CenterViewModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class CenterViewModel
    {
        public int    CenterCode      { get; set; }
        public string CenterID        { get; set; }
        public string CenterKey       { get; set; }
        public int    OrderType       { get; set; }
        public int    CenterType      { get; set; }
        public string CenterTypeM     { get; set; }
        public string CenterName      { get; set; }
        public string CorpNo          { get; set; }
        public string CeoName         { get; set; }
        public string BizType         { get; set; }
        public string BizClass        { get; set; }
        public string TelNo           { get; set; }
        public string FaxNo           { get; set; }
        public string Email           { get; set; }
        public string BankCode        { get; set; }
        public string BankName        { get; set; }
        public string EncAcctNo       { get; set; }
        public string SearchAcctNo    { get; set; }
        public string AcctName        { get; set; }
        public string AcctValidFlag   { get; set; }
        public string AddrPost        { get; set; }
        public string Addr            { get; set; }
        public string CenterNote      { get; set; }  
        public string HeadCenterCodes { get; set; }
        public double TransSaleRate   { get; set; }
        public string DeptUserID      { get; set; }
        public string EncDeptUserPwd  { get; set; }  
        public int    RegType         { get; set; }
        public string ContractFlag    { get; set; }
        public string ContractFlagM   { get; set; }
        public string UseFlag         { get; set; }
        public string UseFlagM        { get; set; }
        public string RegAdminID      { get; set; }
        public string RegDate         { get; set; }
        public string UpdAdminID      { get; set; }
        public string UpdDate         { get; set; }

    }

    public class ReqCenterFranchiseList
    {
        public int    CenterCode       { get; set; } //조회한 회원사 코드(입력시 회원사 목록에서 제외함)
        public string AccessCenterCode { get; set; }
        public int    HeadCenterCode   { get; set; } //본부 회원사 코드
        public string AddHeadFlag      { get; set; } //본부 포함 여부
        public string AddBranchFlag    { get; set; } //가맹점 포함여부
        public string AddContractFlag  { get; set; } //협력사 포함여부
    }

    public class ResCenterFranchiseList
    {
        public List<CenterViewModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }
}