using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ReqSecurityFieldList
    {
        public string FieldName { get; set; }
        public int    PageSize  { get; set; }
        public int    PageNo    { get; set; }

    }

    public class ResSecurityFieldList
    {
        public List<SecurityFieldViewModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class SecurityFieldViewModel
    {
        public string FieldName   { get; set; }
        public int    MarkCharCnt { get; set; }
        public string FieldDesc   { get; set; }
        public string UseFlag     { get; set; }
        public string UseFlagM    { get; set; }
        public string AdminID     { get; set; }
        public string RegDate     { get; set; }
        public string UpdDate     { get; set; }
    }

    public class ReqServerAllowipList
    {
        public string ServerType  { get; set; }
        public int    CenterCode  { get; set; }
        public string AllowIPAddr { get; set; }
        public string UseFlag     { get; set; }
        public int    PageSize    { get; set; }

        public int    PageNo      { get; set; }

    }

    public class ResServerAllowipList
    {
        public List<ServerAllowipViewModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class ServerAllowipViewModel
    {
        public string ServerType  { get; set; }
        public int    CenterCode  { get; set; }
        public string CenterName  { get; set; }
        public string AllowIPAddr { get; set; }
        public string AllowIPDesc { get; set; }
        public string UseFlag     { get; set; }
        public string UseFlagM    { get; set; }
        public string AdminID     { get; set; }
        public string RegDate     { get; set; }
        public string UpdDate     { get; set; }
    }

    public class ReqServerList
    {
        public string ServerType { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }

    }

    public class ResServerList
    {
        public List<ServerViewModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class ServerViewModel
    {
        public string ServerType       { get; set; }
        public string ServerName       { get; set; }
        public int    ServerPort       { get; set; }
        public string ServerIPAddr1    { get; set; }
        public string ServerIPAddr2    { get; set; }
        public int    ServerStateCode  { get; set; }
        public string ServerStateCodeM { get; set; }
        public string StartDate        { get; set; }
        public string StopDate         { get; set; }
        public string RegDate          { get; set; }
    }

    public class ReqServerConfigList
    {
        public string ServerType { get; set; }
        public string KeyName    { get; set; }
        public string KeyVal     { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }
    }

    public class ResServerConfigList
    {
        public List<ServerConfigViewModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ServerConfigViewModel
    {
        public string ServerType { get; set; }
        public string KeyName    { get; set; }
        public string KeyVal     { get; set; }
        public string AdminID    { get; set; }
        public string RegDate    { get; set; }
        public string UpdDate    { get; set; }
    }

    public class ReqCodeList
    {
        public string CodeName { get; set; }
        public string CodeVal { get; set; }
        public string CodeDesc { get; set; }
        public int PageSize { get; set; }
        public int PageNo { get; set; }

    }

    public class ResCodeList
    {
        public List<CodeViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class CodeViewModel
    {
        public string CodeName      { get; set; }
        public string CodeVal       { get; set; }
        public string CodeDesc      { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdDate       { get; set; }
    }
}