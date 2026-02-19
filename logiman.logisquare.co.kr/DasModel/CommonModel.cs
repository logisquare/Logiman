using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class BankModel
    {
        public string BankCode    { get; set; }
        public string BankName    { get; set; }
        public string DisplayFlag { get; set; }
    }

    public class ReqBankList
    {
        public string BankCode    { get; set; }
        public string BankName   { get; set; }
        public int    PageSize    { get; set; }
        public int    PageNo      { get; set; }
    }

    public class ResBankList
    {
        public List<BankModel> list      { get; set; }
        public int             RecordCnt { get; set; }
    }

    public class MobileAuthLogModel
    {
        public string TryYMD      { get; set; }
        public string MobileNo    { get; set; }
        public int    TryCnt      { get; set; } = 0;
        public int    ResetCnt    { get; set; } = 0;
        public string RegDate     { get; set; }
        public string UpdDate     { get; set; }
    }
}