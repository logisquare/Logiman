using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class AdminPwdInfo
    {
        public string CurrPassword      { get; set; }
        public int    TodayLoginFailCnt { get; set; }
        public int    AdminLogInTryCnt  { get; set; }
        public int    GradeCode         { get; set; }
        public string UseFlag           { get; set; }
    }

    public class AdminPrevPwdInfo
    {
        public string[] arrPrevPassword   { get; set; }
    }

    public class AdminMenuChk
    {
        public int AuthCode { get; set; }
    }

    public class CorpNoCheck
    {
        public string CorpName   { get; set; }
        public string ExistsFlag { get; set; }
    }

    public class PasswordReset
    {
        public string Token           { get; set; }
        public int    UseLangTypeCode { get; set; }
        public string AdminID         { get; set; }
    }

    public class AdminSessionInfo
    {
        public string AdminID               { get; set; } = string.Empty;
        public string MobileNo              { get; set; } = string.Empty;
        public string AdminName             { get; set; } = string.Empty;
        public int    GradeCode             { get; set; }
        public string GradeName             { get; set; } = string.Empty;
        public string PrivateAvailFlag      { get; set; } = string.Empty;
        public string LastLoginDate         { get; set; } = string.Empty;
        public string LastLoginIP           { get; set; } = string.Empty;
        public string PwdUpdDate            { get; set; } = string.Empty;
        public string AccessCenterCode      { get; set; } = string.Empty;
        public string AccessCorpNo          { get; set; } = string.Empty;
        public string SessionKey            { get; set; } = string.Empty;
        public int    AuthCode              { get; set; } = 99;
        public string Network24DDID         { get; set; } = string.Empty;
        public string NetworkHMMID          { get; set; } = string.Empty;
        public string NetworkOneCallID      { get; set; } = string.Empty;
        public string NetworkHmadangID      { get; set; } = string.Empty;
        public string DeptName              { get; set; } = string.Empty;
        public string Position              { get; set; } = string.Empty;
        public string TelNo                 { get; set; } = string.Empty;
        public string Email                 { get; set; } = string.Empty;
        public string WebTemplate           { get; set; } = string.Empty;
        public string ExpireYmd             { get; set; } = string.Empty;
        public string OrderLocationCodes    { get; set; } = string.Empty;
        public string OrderItemCodes        { get; set; } = string.Empty;
        public string OrderStatusCodes      { get; set; } = string.Empty;
        public string DeliveryLocationCodes { get; set; } = string.Empty;
        public string MyOrderFlag           { get; set; } = string.Empty;
    }

    public class ReqAdminLeftMenuList
    {
        public string AdminID       { get; set; }
        public int    MenuGroupNo   { get; set; }
        public int    MenuGroupKind { get; set; }
    }

    public class ResAdminLeftMenuGroupList
    {
        public List<AdminLeftMenuGroupList> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class AdminLeftMenuGroupList
    {
        public int    MenuGroupNo   { get; set; }
        public int    MenuGroupKind { get; set; }
        public string MenuGroupName { get; set; }
        public int    MenuGroupSort { get; set; }
        public string DisplayImage  { get; set; }
    }

    public class ResAdminLeftMenuList
    {
        public List<AdminLeftMenuList> list      { get; set; }
        public int                     RecordCnt { get; set; } = 0;
    }

    public class AdminLeftMenuList
    {
        public int    MenuNo        { get; set; }
        public string MenuGroupName { get; set; }
        public string MenuName      { get; set; }
        public int    MenuSort      { get; set; }
        public string MenuLink      { get; set; }
        public string MenuDesc      { get; set; }
    }

    public class ReqBoardManagerList
    {
        public int    SeqNo            { get; set; }
        public int    BoardViewType    { get; set; }
        public string MainDisplayFlag  { get; set; }
        public int    BoardKind        { get; set; }
        public string BoardTitle       { get; set; }

        public string BoardContent     { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string UseFlag          { get; set; }
        public string AdminName        { get; set; }

        public string FromYMD          { get; set; }
        public string ToYMD            { get; set; }
        public string ToDayYMD         { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResBoardManagerList
    {
        public List<BoardManagerViewModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class BoardManagerViewModel
    {
        public int    SeqNo            { get; set; }
        public int    BoardViewType    { get; set; }
        public int    BoardKind        { get; set; }
        public string BoardKindTxt     { get; set; }
        public string MainDisplayFlag  { get; set; }

        public string BoardTitle       { get; set; }
        public string BoardContent     { get; set; }
        public string UseFlag          { get; set; }
        public string YMD              { get; set; }
        public int    AccessGradeCode  { get; set; }

        public string GradeName        { get; set; }
        public string UseGradeName     { get; set; }
        public string AccessCenterCode { get; set; }
        public string CenterName       { get; set; }
        public string UserCenterName   { get; set; }

        public int    ViewCnt          { get; set; }
        public int    DisplaySort      { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
        public string StartDate        { get; set; }

        public string EndDate          { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
        public string UpdDate          { get; set; }

        public string AvailCenterFlag  { get; set; }
        public string AvailGradeFlag   { get; set; }
    }

    public class ReqAdminList
    {
        public string AdminID          { get; set; }
        public int    CenterCode       { get; set; }
        public int    ClientCode       { get; set; }
        public string MobileNo         { get; set; }
        public string AdminName        { get; set; }

        public int    GradeCode        { get; set; }
        public string UseFlag          { get; set; }
        public int    SesGradeCode     { get; set; }
        public string AccessGradeCode  { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }

        public int    PageNo           { get; set; }
    }

    public class ResAdminList
    {
        public List<AdminViewModel> list      { get; set; }
        public int              RecordCnt { get; set; }
    }

    public class AdminViewModel
    {
        public string AdminID               { get; set; }
        public string AdminPwd              { get; set; }
        public string MobileNo              { get; set; }
        public string AdminName             { get; set; }
        public int    GradeCode             { get; set; }
        public string GradeCodeM            { get; set; }
        public string GradeName             { get; set; }
        public string AdminCorpNo           { get; set; }
        public string AdminCorpName         { get; set; }
        public string PrivateAvailFlag      { get; set; }
        public string DeptName              { get; set; }
        public string TelNo                 { get; set; }
        public string Email                 { get; set; }
        public string AdminPosition         { get; set; } 
        public string WebTemplate           { get; set; }
        public string AccessIPChkFlag       { get; set; }
        public string AccessIP1             { get; set; }
        public string AccessIP2             { get; set; }
        public string AccessIP3             { get; set; }
        public string LastLoginDate         { get; set; }
        public string LastLoginIP           { get; set; }
        public string JoinYMD               { get; set; }
        public string ExpireYMD             { get; set; }
        public string PwdUpdDate            { get; set; }
        public string AccessCenterCode      { get; set; }
        public string AccessCorpNo          { get; set; }
        public string Network24DDID         { get; set; }
        public string NetworkHMMID          { get; set; }
        public string NetworkOneCallID      { get; set; }
        public string NetworkHmadangID      { get; set; }
        public string UseFlag               { get; set; }
        public string UseFlagM              { get; set; }
        public int    RegReqType            { get; set; }
        public string RegReqTypeM           { get; set; }
        public string RegAdminID            { get; set; }
        public string RegDate               { get; set; }
        public string UpdDate               { get; set; }
        public int    AccessCnt             { get; set; }
        public string RollName              { get; set; }
        public int    RollCnt               { get; set; }
        public string CenterName            { get; set; }
        public string ExitDate              { get; set; }
        public int    CenterCode            { get; set; }
        public int    ClientCode            { get; set; }
        public int    SeqNo                 { get; set; }
        public string ClientInfo            { get; set; }
        public string OrderLocationCodes    { get; set; }
        public string OrderItemCodes        { get; set; }
        public string OrderStatusCodes      { get; set; }
        public string DeliveryLocationCodes { get; set; }
        public string DupLoginFlag          { get; set; }
        public string DupLoginFlagM         { get; set; }
        public string MyOrderFlag           { get; set; }
        public string MyOrderFlagM          { get; set; }
    }

    public class ResAdminMenuAccessList
    {
        public List<AdminMenuAccessViewModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class AdminMenuAccessViewModel
    {
        public int    MenuGroupNo    { get; set; }
        public int    MenuNo         { get; set; }
        public string MenuName       { get; set; }
        public int    Depth          { get; set; }
        public int    SortNo         { get; set; }
        public int    PSortNo        { get; set; }
        public int    UseStateCode   { get; set; }
        public int    AuthCode       { get; set; }
        public string AdminID        { get; set; }
        public int    AccessTypeCode { get; set; }
        public string AddMenuList    { get; set; }
        public string RmMenuList     { get; set; }
        public string AllAuthCode    { get; set; }
        public string RwAuthCode     { get; set; }
        public string RoAuthCode     { get; set; }

    }

    public class ResAdminMenuRoleAccessList
    {
        public List<AdminMenuRoleAccessViewModel> list      { get; set; }
        public int                                RecordCnt { get; set; }
    }

    public class AdminMenuRoleAccessViewModel
    {
        public int    MenuRoleNo   { get; set; }
        public string MenuRoleName { get; set; }
        public string UseFlag      { get; set; }
        public string RegDate      { get; set; }
        public string UpdDate      { get; set; }
    }

    public class ResAdminLeftMenuAllList
    {
        public List<AdminLeftMenuAllList> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class AdminLeftMenuAllList
    {
        public int    MenuGroupNo   { get; set; }
        public int    MenuGroupKind { get; set; }
        public int    MenuGroupSort { get; set; }
        public string MenuGroupName { get; set; }
        public string MenuName      { get; set; }
        public string MenuDesc      { get; set; }
        public string MenuLink      { get; set; }
        public int    MenuSort      { get; set; }
    }

    public class AdminCodesModel
    {
        public string AdminID               { get; set; }
        public string OrderLocationCodes    { get; set; } = string.Empty;
        public string OrderItemCodes        { get; set; } = string.Empty;
        public string OrderStatusCodes      { get; set; } = string.Empty;
        public string DeliveryLocationCodes { get; set; } = string.Empty;
    }
}