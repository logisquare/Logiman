using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class NetworkViewModel
    {
        public int RuleSeqNo { get; set; }
        public int RuleType { get; set; }
        public int CenterCode { get; set; }
        public int NetworkKind { get; set; }
        public int ClientCode { get; set; }
        public int ConsignorCode { get; set; }
        public int RenewalStartMinute { get; set; }
        public int RenewalIntervalMinute { get; set; }
        public double RenewalIntervalPrice { get; set; }
        public int RenewalModMinute { get; set; }
        public string UseFlag { get; set; }
        public string RegAdminName { get; set; }
        public string RegAdminID { get; set; }
        public string UpdAdminID { get; set; }
        public string RegYMD { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }
    }
    public class ReqNetworkList
    {
        public int      RuleSeqNo { get; set; }
        public int      RuleType { get; set; }
        public int      CenterCode { get; set; }
        public int      NetworkKind { get; set; }
        public int      ClientCode { get; set; }
        public string   ClientName { get; set; }
        public string   UseFlag { get; set; }
        public string   RegAdminName { get; set; }
        public int      PageSize            { get; set; }
        public int      PageNo              { get; set; }
        
    }

    public class ResNetworkList
    {
        public List<NetworkListListViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class NetworkListListViewModel
    {
        public int RuleSeqNo { get; set; }
        public int RuleType { get; set; }
        public int CenterCode { get; set; }
        public string CenterName { get; set; }
        public int NetworkKind { get; set; }
        public string NetworkKindM { get; set; }
        public int ClientCode { get; set; }
        public string ClientName { get; set; }
        public int ConsignorCode { get; set; }
        public string ConsignorCodeM { get; set; }
        public int RenewalStartMinute { get; set; }
        public int RenewalIntervalMinute { get; set; }
        public double RenewalIntervalPrice { get; set; }
        public int RenewalModMinute { get; set; }
        public string UseFlag { get; set; }
        public string UseFlagM { get; set; }
        public string RegAdminName { get; set; }
        public string RegAdminID { get; set; }
        public string UpdAdminID { get; set; }
        public string RegYMD { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }
    }

    public class NetworkRuleGridModel
    {
        public int    RuleSeqNo             { get; set; }
        public int    RuleType              { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public int    NetworkKind           { get; set; }
        public string NetworkKindM          { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public string ConsignorCode         { get; set; }
        public string ConsignorCodeM        { get; set; }
        public int    RenewalStartMinute    { get; set; }
        public int    RenewalIntervalMinute { get; set; }
        public double RenewalIntervalPrice  { get; set; }
        public int    RenewalModMinute      { get; set; }
        public string UseFlag               { get; set; }
        public string UseFlagM              { get; set; }
        public string RegAdminName          { get; set; }
        public string RegAdminID            { get; set; }
        public string UpdAdminID            { get; set; }
        public string RegYMD                { get; set; }
        public string RegDate               { get; set; }
        public string UpdDate               { get; set; }
    }

    public class ReqNetworkRuleSearchList
    {
        public int    CenterCode    { get; set; }
        public int    NetworkKind   { get; set; }
        public long   ClientCode    { get; set; }
        public long   ConsignorCode { get; set; }
        public string UseFlag       { get; set; }
        public int    PageSize      { get; set; }
        public int    PageNo        { get; set; }
    }

    public class ResNetworkRuleSearchList
    {
        public List<NetworkRuleGridModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }
}