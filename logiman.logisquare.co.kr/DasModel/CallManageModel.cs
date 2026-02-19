using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class CMInbouncCallView
    {
        public string channel_type    { get; set; } //kt # kt, lguplus, skbroadband, android, apple
        public string call_session_id { get; set; } //kt250627113915356887 (optional)
        public string auth_id         { get; set; } //id, (optional, KT에만 존재)
        public string caller          { get; set; } //01012345678
        public string callee          { get; set; } //07012341111
        public string kind            { get; set; } //call, # or 'sms'
        public string site_code       { get; set; } //SiteCode : logiman, cargomanager, mtruck
        public string state           { get; set; } //ring
        public string message         { get; set; } //문자 메시지 내용이 여기에 들어감.
    }

    public class ReqCalleeInfoList
    {
        public string ChannelType { get; set; }
        public string AuthID      { get; set; }
        public string PhoneNo     { get; set; }
    }

    public class ResCalleeInfoList
    {
        public List<CalleeInfoListModel> list      { get; set; }
        public int                       RecordCnt { get; set; }
    }

    public class ReqCallerInfoGet
    {
        public int    CenterCode       { get; set; }
        public string CustTelNo        { get; set; }
    }

    public class ResCallerInfoGet
    {
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string CallerDetailText { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public long   ClientCode       { get; set; }
        public string Name             { get; set; }
        public string ComName          { get; set; }
        public string CorpNo           { get; set; }
        public string CeoName          { get; set; }
        public string CarNo            { get; set; }
        public string CarTon           { get; set; }
        public string CarType          { get; set; }
        public string PlaceName        { get; set; }
        public string PlaceAddr        { get; set; }
        public string CenterName       { get; set; }
        public string Position         { get; set; }
        public string DeptName         { get; set; }
        public string TaxMsg           { get; set; }
        public int    ClassType        { get; set; }
        public string ClientAdminID    { get; set; }
    }

    public class CalleeInfoListModel
    {
        public int    CenterCode       { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
        public string WebAlarmFlag     { get; set; }
        public string PCAlarmFlag      { get; set; }
        public string AutoPopupFlag    { get; set; }
        public string OrderViewFlag    { get; set; }
        public string CompanyViewFlag  { get; set; }
        public string PurchaseViewFlag { get; set; }
        public string SaleViewFlag     { get; set; }
        public string AppUseFlag       { get; set; }
        public int    GradeCode        { get; set; }
    }

    public class ReqCMOrderTelInfoGet
    {
        public int    CenterCode       { get; set; }
        public string CustTelNo        { get; set; }
    }

    public class ResCMOrderTelInfoGet
    {
        public int CustType { get; set; } //11:화주관리자, 31:기사, 32:차량업체, 51:고객사담당자, 52:고객사, 71:오더정보

        public int
            OrderTelType
        {
            get;
            set;
        } //오더 전화번호 타입(1:발주처전화번호, 2:발주처휴대폰, 3:청구처전화번호, 4:청구처휴대폰, 5:상차지전화번호, 6:상차지휴대폰, 7:하차지전화번호, 8:하차지휴대폰)

        public long   RefSeqNo            { get; set; }
        public long   ComCode             { get; set; }
        public long   ClientCode          { get; set; }
        public string ClientName          { get; set; }
        public string AdminName           { get; set; }
        public string AdminPosition       { get; set; }
        public string DeptName            { get; set; }
        public string CarNo               { get; set; }
        public int    CarDivType          { get; set; }
        public string CarDivTypeM         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string CarTonCodeM         { get; set; }
        public string DriverCell          { get; set; }
        public string DriverName          { get; set; }
        public int    TaxKind             { get; set; }
        public string TaxMsg              { get; set; }
        public string ComName             { get; set; }
        public string ComCorpNo           { get; set; }
        public string ComCeoName          { get; set; }
        public string CooperatorFlag      { get; set; }
        public string ChargeName          { get; set; }
        public string ChargePosition      { get; set; }
        public string ChargeDepartment    { get; set; }
        public string ClientType          { get; set; }
        public string ClientTypeM         { get; set; }
        public string ClientCorpNo        { get; set; }
        public string ClientCeoName       { get; set; }
        public string Place               { get; set; }
        public string PlaceAddr           { get; set; }
        public string PlaceChargeName     { get; set; }
        public string PlaceChargePosition { get; set; }
        public string ClientAdminID       { get; set; }
    }

    public class CMLogView
    {
        public int    CenterCode       { get; set; }
        public int    CallType         { get; set; }
        public string CallKind         { get; set; }
        public string ChannelType      { get; set; }
        public string CallNumber       { get; set; }
        public string SendNumber       { get; set; }
        public string SendName         { get; set; }
        public string RcvNumber        { get; set; }
        public string RcvName          { get; set; }
        public string CallSessionID    { get; set; }
        public string AuthID           { get; set; }
        public string Message          { get; set; }
    }

    public class CMLogDtlView
    {
        public string CustTelNo        { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string CallerDetailText { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public long   ClientCode       { get; set; }
        public string Name             { get; set; }
        public string ComName          { get; set; }
        public string CorpNo           { get; set; }
        public string CeoName          { get; set; }
        public string CarNo            { get; set; }
        public string CarTon           { get; set; }
        public string CarType          { get; set; }
        public string PlaceName        { get; set; }
        public string PlaceAddr        { get; set; }
        public string Position         { get; set; }
        public string DeptName         { get; set; }
        public string TaxMsg           { get; set; }
        public int    ClassType        { get; set; }
    }

    public class ReqCMLogInboundIns
    {
        public CMLogView    CmLog    { get; set; }
        public CMLogDtlView CmLogDtl { get; set; }
    }

    public class ResCMLogInboundIns
    {
        public long SeqNo      { get; set; }
        public int  CenterCode { get; set; }
    }

    public class CMMobileInboundCallView
    {
        public string ChannelType      { get; set; } //kt # kt, lguplus, skbroadband, android, apple
        public string SendNumber       { get; set; } // 발신자(차주, 고객사 등...)
        public string RcvNumber        { get; set; } // 수신자(앱 휴대폰번호)
        public string Message          { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string CallerDetailText { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public long   ClientCode       { get; set; }
        public string Name             { get; set; }
        public string ComName          { get; set; }
        public string CorpNo           { get; set; }
        public string CeoName          { get; set; }
        public string CarNo            { get; set; }
        public string CarTon           { get; set; }
        public string CarType          { get; set; }
        public string PlaceName        { get; set; }
        public string PlaceAddr        { get; set; }
        public long   CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public string Position         { get; set; }
        public string DeptName         { get; set; }
        public string TaxMsg           { get; set; }
        public int    ClassType        { get; set; }
        public string ClientAdminID    { get; set; }
    }

    public class ReqAuthInfoList
    {
        public int    AuthSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public string ChannelType      { get; set; }
        public string AuthID           { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResAuthInfoList
    {
        public List<AuthInfoListModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class AuthInfoListModel
    {
        public int    AuthSeqNo    { get; set; }
        public int    CenterCode   { get; set; }
        public string CenterName   { get; set; }
        public string ChannelType  { get; set; }
        public string ChannelTypeM { get; set; }
        public string AuthID       { get; set; }
        public string AuthPwd      { get; set; }
        public string MaskAuthPwd  { get; set; }
        public string AdminID      { get; set; }
        public string AdminName    { get; set; }
        public string UseFlag      { get; set; }
        public string UseFlagM     { get; set; }
        public string RegYMD       { get; set; }
        public string RegDate      { get; set; }
        public string UpdDate      { get; set; }
    }

    public class ReqAuthInfoIns
    {
        public int    CenterCode  { get; set; }
        public string ChannelType { get; set; }
        public string AuthID      { get; set; }
        public string AuthPwd     { get; set; }
        public string AdminID     { get; set; }
        public string AdminName   { get; set; }
    }

    public class ResAuthInfoIns
    {
        public int AuthSeqNo { get; set; }
    }

    public class ReqAuthInfoDel
    {
        public int    CenterCode { get; set; }
        public int    AuthSeqNo  { get; set; }
        public string AdminID    { get; set; }
        public string AdminName  { get; set; }
    }

    public class ReqAuthPhoneList
    {
        public int    PhoneSeqNo       { get; set; }
        public int    AuthIdx          { get; set; }
        public int    PhoneIdx         { get; set; }
        public int    AuthSeqNo        { get; set; }
        public string ChannelType      { get; set; }
        public string PhoneNo          { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResAuthPhoneList
    {
        public List<AuthPhoneListModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class AuthPhoneListModel
    {
        public int    PhoneSeqNo  { get; set; }
        public int    AuthIdx     { get; set; }
        public int    PhoneIdx    { get; set; }
        public int    AuthSeqNo   { get; set; }
        public string ChannelType { get; set; }
        public string CreateTs    { get; set; }
        public string PhoneNo     { get; set; }
        public string PhoneMemo   { get; set; }
        public string UseFlag     { get; set; }
        public string UseFlagM    { get; set; }
        public string AdminID     { get; set; }
        public string AdminName   { get; set; }
        public string RegYMD      { get; set; }
        public string RegDate     { get; set; }
        public string UpdDate     { get; set; }
        public string AuthID      { get; set; }
    }

    public class ReqAuthPhoneAvailList
    {
        public int    AuthSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public string ChannelType      { get; set; }
        public string AuthID           { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResAuthPhoneAvailList
    {
        public List<AuthPhoneAvailListModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class AuthPhoneAvailListModel
    {
        public int    AuthSeqNo            { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string ChannelType          { get; set; }
        public string ChannelTypeM         { get; set; }
        public string AuthID               { get; set; }
        public string UseFlag              { get; set; }
        public string UseFlagM             { get; set; }
        public int    PhoneSeqNo           { get; set; }
        public int    AuthIdx              { get; set; }
        public int    PhoneIdx             { get; set; }
        public string PhoneNo              { get; set; }
        public string PhoneMemo            { get; set; }
        public string PhoneUseFlag         { get; set; }
        public string PhoneUseFlagUseFlagM { get; set; }
        public string RegYMD               { get; set; }
    }

    public class ReqAuthPhoneIns
    {
        public int    CenterCode  { get; set; }
        public string ChannelType { get; set; }
        public string AuthID      { get; set; }
        public int    AuthSeqNo   { get; set; }
        public int    AuthIdx     { get; set; }
        public int    PhoneIdx    { get; set; }
        public string CreateTs    { get; set; }
        public string PhoneNo     { get; set; }
        public string AdminID     { get; set; }
        public string AdminName   { get; set; }
    }

    public class ResAuthPhoneIns
    {
        public int    PhoneSeqNo  { get; set; }
    }

    public class ReqAuthPhoneUpd
    {
        public int    PhoneSeqNo { get; set; }
        public string PhoneMemo  { get; set; }
        public string UseFlag    { get; set; }
        public string AdminID    { get; set; }
        public string AdminName  { get; set; }
    }

    public class ReqCMAdminIns
    {
        public string AdminID          { get; set; }
        public string WebAlarmFlag     { get; set; }
        public string PCAlarmFlag      { get; set; }
        public string AutoPopupFlag    { get; set; }
        public string OrderViewFlag    { get; set; }
        public string CompanyViewFlag  { get; set; }
        public string PurchaseViewFlag { get; set; }
        public string SaleViewFlag     { get; set; }
    }

    public class ReqCMAdminPhoneMultiUpd
    {
        public string AdminID      { get; set; }
        public string PhoneSeqNos  { get; set; }
        public string MainUseFlags { get; set; }
    }
    
    public class CMJsonParamModel
    {
        public string SeqNo            { get; set; }      //LogSeqNo
        public int    CenterCode       { get; set; } = 0;
        public string SndTelNo         { get; set; }
        public string RcvTelNo         { get; set; }
        public int    CallerType       { get; set; } = 0; //1: 차량, 2: 고객사, 3:관리자, 4:미등록
        public int    CallerDetailType { get; set; } = 0; //31: 기사, 32: 차량업체, 51: 고객사담당자, 52: 고객사, 11: 화주관리자, 21: 운송사, 71: 오더정보, 99: 없음
        public string CallerDetailText { get; set; }      //뱃지 표시 텍스트(직영, 단기, 화주, 운송, 등)
        public string Name             { get; set; }      //성명
        public string ComName          { get; set; }      //업체명
        public string CorpNo           { get; set; }      //사업자번호
        public string CeoName          { get; set; }      //대표자명
        public string CarNo            { get; set; }      //차량번호
        public string CarTon           { get; set; }      //톤수
        public string CarType          { get; set; }      //차종
        public string PlaceName        { get; set; }      //상/하차지명
        public string PlaceAddr        { get; set; }      //상/하차지 주소
        public string CenterName       { get; set; }      //회원사명
        public string Position         { get; set; }      //직급
        public string DeptName         { get; set; }      //부서명
        public string TaxMsg           { get; set; }
        public int    ClassType        { get; set; } = 1; //평가구분
        public string RefSeqNo         { get; set; }
        public string ComCode          { get; set; }
        public string ClientCode       { get; set; }
        public string ClientAdminID    { get; set; }
    }

    public class ReqCMClassifyIns
    {
        public int    CenterCode   { get; set; }
        public string CallerNumber { get; set; }
        public int    ClassType    { get; set; }
        public string AdminID      { get; set; }
        public string AdminName    { get; set; }
    }

    public class ResCMClassifyIns
    {
        public int SeqNo     { get; set; }
        public int ClassType { get; set; }
    }

    public class ReqCMOrderList
    {
        public int    CenterCode       { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string SndTelNo         { get; set; }
        public long   ClientCode       { get; set; }
        public string ClientAdminID    { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMOrderModel
    {
        public int    CenterCode             { get; set; }
        public string CenterName             { get; set; }
        public string OrderNo                { get; set; }
        public string OrderItemCode          { get; set; }
        public string OrderItemCodeM         { get; set; }
        public string OrderLocationCode      { get; set; }
        public string OrderLocationCodeM     { get; set; }
        public string OrderClientCode        { get; set; }
        public string OrderClientName        { get; set; }
        public string OrderClientChargeName  { get; set; }
        public string OrderClientChargeTelNo { get; set; }
        public string PayClientCode          { get; set; }
        public string PayClientName          { get; set; }
        public string ConsignorCode          { get; set; }
        public string ConsignorName          { get; set; }
        public string PickupYMD              { get; set; }
        public string PickupHM               { get; set; }
        public string PickupPlace            { get; set; }
        public string PickupPlaceAddr        { get; set; }
        public string PickupPlaceAddrDtl     { get; set; }
        public string GetYMD                 { get; set; }
        public string GetHM                  { get; set; }
        public string GetPlace               { get; set; }
        public string GetPlaceAddr           { get; set; }
        public string GetPlaceAddrDtl        { get; set; }
        public int    OrderStatus            { get; set; }
        public string OrderStatusM           { get; set; }
        public string RegDate                { get; set; }
        public string RegAdminID             { get; set; }
        public string RegAdminName           { get; set; }
        public string UpdDate                { get; set; }
        public string UpdAdminID             { get; set; }
        public string UpdAdminName           { get; set; }
        public string UpdAdminTelNo          { get; set; }
        public string AcceptDate             { get; set; }
        public string AcceptAdminID          { get; set; }
        public string AcceptAdminName        { get; set; }
        public string AcceptAdminTelNo       { get; set; }
        public string SaleClosingSeqNo       { get; set; }
        public double SaleSupplyAmt          { get; set; }
        public double SaleTaxAmt             { get; set; }
        public string PickupCarNo            { get; set; }
        public string PickupDriverName       { get; set; }
        public string PickupDriverCell       { get; set; }
        public string GetCarNo               { get; set; }
        public string GetDriverName          { get; set; }
        public string GetDriverCell          { get; set; }
    }

    public class ResCMOrderList
    {
        public List<CMOrderModel> list      { get; set; }
        public int                RecordCnt { get; set; }
    }

    public class ReqCMOrderDispatchList
    {
        public int    CenterCode       { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string SndTelNo         { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMOrderDispatchModel
    {
        public int    CenterCode             { get; set; }
        public string CenterName             { get; set; }
        public string OrderNo                { get; set; }
        public string OrderItemCode          { get; set; }
        public string OrderItemCodeM         { get; set; }
        public string OrderLocationCode      { get; set; }
        public string OrderLocationCodeM     { get; set; }
        public string OrderClientCode        { get; set; }
        public string OrderClientName        { get; set; }
        public string OrderClientChargeName  { get; set; }
        public string OrderClientChargeTelNo { get; set; }
        public string PayClientCode          { get; set; }
        public string PayClientName          { get; set; }
        public string ConsignorCode          { get; set; }
        public string ConsignorName          { get; set; }
        public string PickupYMD              { get; set; }
        public string PickupHM               { get; set; }
        public string PickupPlace            { get; set; }
        public string PickupPlaceAddr        { get; set; }
        public string PickupPlaceAddrDtl     { get; set; }
        public string GetYMD                 { get; set; }
        public string GetHM                  { get; set; }
        public string GetPlace               { get; set; }
        public string GetPlaceAddr           { get; set; }
        public string GetPlaceAddrDtl        { get; set; }
        public string RegDate                { get; set; }
        public string RegAdminID             { get; set; }
        public string RegAdminName           { get; set; }
        public string UpdDate                { get; set; }
        public string UpdAdminID             { get; set; }
        public string UpdAdminName           { get; set; }
        public string UpdAdminTelNo          { get; set; }
        public string AcceptDate             { get; set; }
        public string AcceptAdminID          { get; set; }
        public string AcceptAdminName        { get; set; }
        public string AcceptAdminTelNo       { get; set; }
        public int    DispatchType           { get; set; }
        public string DispatchTypeM          { get; set; }
        public int    CarDivType             { get; set; }
        public string CarDivTypeM            { get; set; }
        public string ComName                { get; set; }
        public string ComCeoName             { get; set; }
        public string ComCorpNo              { get; set; }
        public string CarNo                  { get; set; }
        public string DriverName             { get; set; }
        public string DriverCell             { get; set; }
        public string CarTonCode             { get; set; }
        public string CarTonCodeM            { get; set; }
        public string CarTypeCode            { get; set; }
        public string CarTypeCodeM           { get; set; }
        public string DispatchStatus         { get; set; }
        public string DispatchStatusM        { get; set; }
        public string DispatchAdminID        { get; set; }
        public string DispatchAdminName      { get; set; }
        public string DispatchAdminTelNo     { get; set; }
        public string DispatchYMD            { get; set; }
        public string DispatchDate           { get; set; }
        public string DispatchSeqNo          { get; set; }
        public double PurchaseSupplyAmt      { get; set; }
    }

    public class ResCMOrderDispatchList
    {
        public List<CMOrderDispatchModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }

    public class ReqCMOrderSaleClosingList
    {
        public int    CenterCode       { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string SndTelNo         { get; set; }
        public long   ClientCode       { get; set; }
        public string ClientAdminID    { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }

    }

    public class CMOrderSaleClosingModel
    {
        public string SaleClosingSeqNo      { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string ClientCode            { get; set; }
        public string ClientName            { get; set; }
        public string ClientCorpNo          { get; set; }
        public string ClientCeoName         { get; set; }
        public string ClientBizType         { get; set; }
        public string ClientBizClass        { get; set; }
        public string ClientTelNo           { get; set; }
        public string ClientAddr            { get; set; }
        public int    ClientStatus          { get; set; }
        public string ClientStatusM         { get; set; }
        public string ClientCloseYMD        { get; set; }
        public int    ClientClosingType     { get; set; }
        public string ClientClosingTypeM    { get; set; }
        public int    ClientTaxKind         { get; set; }
        public string ClientTaxKindM        { get; set; }
        public string ClientPayDay          { get; set; }
        public int    ClientBusinessStatus  { get; set; }
        public string ClientBusinessStatusM { get; set; }
        public double OrgAmt                { get; set; }
        public double SupplyAmt             { get; set; }
        public double TaxAmt                { get; set; }
        public int    BillStatus            { get; set; }
        public string BillStatusM           { get; set; }
        public int    BillKind              { get; set; }
        public string BillKindM             { get; set; }
        public string BillChargeName        { get; set; }
        public string BillChargeTelNo       { get; set; }
        public string BillChargeEmail       { get; set; }
        public string BillWrite             { get; set; }
        public string BillYMD               { get; set; }
        public string BillAdminID           { get; set; }
        public string BillAdminName         { get; set; }
        public string BillDate              { get; set; }
        public string NtsConfirmNum         { get; set; }
        public string Note                  { get; set; }
        public int    ClosingKind           { get; set; }
        public string ClosingKindM          { get; set; }
        public string ClosingAdminID        { get; set; }
        public string ClosingAdminName      { get; set; }
        public string ClosingAdminTelNo     { get; set; }
        public string ClosingYMD            { get; set; }
        public string ClosingDate           { get; set; }
        public int    PayStatus             { get; set; }
        public string PayStatusM            { get; set; }
        public string PayYMD                { get; set; }
        public string PayChargeName         { get; set; }
        public string PayChargeCell         { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdAdminName          { get; set; }
        public string UpdDate               { get; set; }
        public string PickupYMDFrom         { get; set; }
        public string PickupYMDTo           { get; set; }
        public int    OrderCnt              { get; set; }
        public string CsAdminNames          { get; set; }
    }

    public class ResCMOrderSaleClosingList
    {
        public List<CMOrderSaleClosingModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class ReqCMOrderPurchaseClosingList
    {
        public int    CenterCode       { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string SndTelNo         { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMOrderPurchaseClosingModel
    {
        public string PurchaseClosingSeqNo { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
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
        public string DeductFlag           { get; set; }
        public string PickupYMDFrom        { get; set; }
        public string PickupYMDTo          { get; set; }
        public int    OrderCnt             { get; set; }
        public int    BillStatus           { get; set; }
        public string BillStatusM          { get; set; }
        public int    BillKind             { get; set; }
        public string BillKindM            { get; set; }
        public string BillWrite            { get; set; }
        public string BillYMD              { get; set; }
        public string BillDate             { get; set; }
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
        public string ClosingAdminTelNo    { get; set; }
        public string ClosingYMD           { get; set; }
        public string ClosingDate          { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
        public string UpdDate              { get; set; }
        public double InputDeductAmt       { get; set; }
        public string InsureFlag           { get; set; }
        public double TransCost            { get; set; }
        public double InsureRateAmt        { get; set; }
        public double InsureReduceAmt      { get; set; }
        public double DriverInsureAmt      { get; set; }
        public double NotiDriverInsureAmt  { get; set; }
        public double CenterInsureAmt      { get; set; }
        public double NotiCenterInsureAmt  { get; set; }
        public string ComCode              { get; set; }
        public string ComCorpNo            { get; set; }
        public string ComKindM             { get; set; }
        public string ComCeoName           { get; set; }
        public string ComBizType           { get; set; }
        public string ComBizClass          { get; set; }
        public string ComTelNo             { get; set; }
        public string ComFaxNo             { get; set; }
        public string ComEmail             { get; set; }
        public int    ComStatus            { get; set; }
        public string ComStatusM           { get; set; }
        public string ComUpdYMD            { get; set; }
        public string ComCloseYMD          { get; set; }
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
    }

    public class ResCMOrderPurchaseClosingList
    {
        public List<CMOrderPurchaseClosingModel> list      { get; set; }
        public int                               RecordCnt { get; set; }
    }
    public class ReqCMCarDispatchRefList
    {
        public int    CenterCode       { get; set; }
        public int    CallerType       { get; set; }
        public int    CallerDetailType { get; set; }
        public string SndTelNo         { get; set; }
        public long   RefSeqNo         { get; set; }
        public long   ComCode          { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMCarDispatchRefModel
    {
        public string RefSeqNo           { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public int    CarDivType         { get; set; }
        public string CarDivTypeM        { get; set; }
        public string RefNote            { get; set; }
        public string CargoManFlag       { get; set; }
        public string RefUseFlag         { get; set; }
        public string ComCode            { get; set; }
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
        public string ComStatusM         { get; set; }
        public string ComCloseYMD        { get; set; }
        public string ComUpdYMD          { get; set; }
        public int    ComTaxKind         { get; set; }
        public string ComTaxKindM        { get; set; }
        public string ComTaxMsg          { get; set; }
        public string CardAgreeFlag      { get; set; }
        public string CardAgreeYMD       { get; set; }
        public string DtlSeqNo           { get; set; }
        public string PayDay             { get; set; }
        public string BankCode           { get; set; }
        public string BankName           { get; set; }
        public string EncAcctNo          { get; set; }
        public string SearchAcctNo       { get; set; }
        public string AcctName           { get; set; }
        public string AcctValidFlag      { get; set; }
        public string CooperatorFlag     { get; set; }
        public string ChargeName         { get; set; }
        public string ChargeTelNo        { get; set; }
        public string ChargeEmail        { get; set; }
        public string CarSeqNo           { get; set; }
        public string CarNo              { get; set; }
        public string CarTypeCode        { get; set; }
        public string CarTypeCodeM       { get; set; }
        public string CarSubType         { get; set; }
        public string CarTonCode         { get; set; }
        public string CarTonCodeM        { get; set; }
        public string CarBrandCode       { get; set; }
        public string CarBrandCodeM      { get; set; }
        public string CarNote            { get; set; }
        public string DriverSeqNo        { get; set; }
        public string DriverName         { get; set; }
        public string DriverCell         { get; set; }
        public string InsureTargetFlag   { get; set; }
        public string InformationFlag    { get; set; }
        public string InformationDate    { get; set; }
        public string InformationFlagM   { get; set; }
        public string AgreementFlag      { get; set; }
        public string AgreementDate      { get; set; }
        public string AgreementFlagM     { get; set; }
        public string UpdAdminID         { get; set; }
        public string UpdDate            { get; set; }
        public string CenterContractFlag { get; set; }
        public string ComKindM           { get; set; }
    }

    public class ResCMCarDispatchRefList
    {
        public List<CMCarDispatchRefModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ResCMInfoList
    {
        public int                               RetCode                       { get; set; }
        public string                            ErrMsg                        { get; set; }
        public string                            OrderViewFlag                 { get; set; }
        public List<CMOrderModel>                OrderList                     { get; set; }
        public int                               OrderRecordCnt                { get; set; }
        public List<CMOrderDispatchModel>        OrderDispatchList             { get; set; }
        public int                               OrderDispatchRecordCnt        { get; set; } = 0;
        public string                            SaleViewFlag                  { get; set; }
        public List<CMOrderSaleClosingModel>     OrderSaleClosingList          { get; set; }
        public int                               OrderSaleClosingRecordCnt     { get; set; } = 0;
        public string                            ClientNote1                   { get; set; }
        public string                            ClientNote2                   { get; set; }
        public string                            ClientNote3                   { get; set; }
        public string                            ClientNote4                   { get; set; }
        public string                            CompanyViewFlag               { get; set; }
        public List<CMCarDispatchRefModel>       CarDispatchRefList            { get; set; }
        public int                               CarDispatchRefRecordCnt       { get; set; } = 0;
        public string                            RefNote                       { get; set; }
        public string                            PurchaseViewFlag              { get; set; }
        public List<CMOrderPurchaseClosingModel> OrderPurchaseClosingList      { get; set; }
        public int                               OrderPurchaseClosingRecordCnt { get; set; } = 0;
        public List<CMMessageSendLogModel>       MessageSendLogList            { get; set; }
        public int                               MessageSendLogRecordCnt       { get; set; } = 0;
    }

    public class ReqCMCallLogList
    {
        public int    CenterCode       { get; set; }
        public string SndTelNo         { get; set; }
        public string AdminID          { get; set; }
        public string CallViewFlag     { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMCallLogModel
    {
        public string LogType     { get; set; }
        public string LogTypeM    { get; set; }
        public string SeqNo       { get; set; }
        public string CenterCode  { get; set; }
        public string CenterName  { get; set; }
        public string Msg         { get; set; }
        public string SubMsg      { get; set; }
        public string ModifyFlag  { get; set; }
        public string AdminID     { get; set; }
        public string AdminName   { get; set; }
        public string RegDateView { get; set; }
    }

    public class ResCMCallLogList
    {
        public List<CMCallLogModel> list      { get; set; }
        public int                  RecordCnt { get; set; }
    }

    public class ReqCMMemoIns
    {
        public int    CenterCode        { get; set; }
        public string CallNumber        { get; set; }
        public int    CallerType        { get; set; }
        public int    CallerDetailType  { get; set; }
        public string CallerDetailText  { get; set; }
        public string CompanyName       { get; set; }
        public string CompanyCeoName    { get; set; }
        public string CompanyChargeName { get; set; }
        public string CompanyMemo       { get; set; }
        public string AdminID           { get; set; }
        public string AdminName         { get; set; }
    }

    public class ResCMMemoIns
    {
        public int SeqNo { get; set; }
    }

    public class ReqCMMemoDel
    {
        public int    CenterCode { get; set; }
        public int    SeqNo      { get; set; }
        public string AdminID    { get; set; }
    }

    public class ReqCMAdminPhoneList
    {

        public string AdminID     { get; set; }
        public int    PhoneSeqNo  { get; set; }
        public string PhoneNo     { get; set; }
        public string MainUseFlag { get; set; }
        public string UseFlag     { get; set; }
        public int    PageSize    { get; set; }
        public int    PageNo      { get; set; }
    }

    public class CMAdminPhoneModel
    {
        public string AdminID      { get; set; }
        public int    PhoneSeqNo   { get; set; }
        public string MainUseFlag  { get; set; }
        public string ChannelType  { get; set; }
        public string ChannelTypeM { get; set; }
        public string PhoneNo      { get; set; }
        public string PhoneMemo    { get; set; }
        public string UseFlag      { get; set; }
        public string RegDate      { get; set; }
        public string UpdDate      { get; set; }
        public string AuthID       { get; set; }
    }
    public class ResCMAdminPhoneList
    {
        public List<CMAdminPhoneModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class ReqCMCallerDetailInfoList
    {
        public int    CenterCode { get; set; }
        public string CustTelNo  { get; set; }
    }

    public class ResCMCallerDetailInfoList
    {
        public List<CMJsonParamModel> list      { get; set; }
        public int                    RecordCnt { get; set; }
    }

    public class ReqCMMessageSendLogList
    {
        public int    CenterCode       { get; set; }
        public string RcvNumber        { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMMessageSendLogModel
    {
        public int    CenterCode { get; set; }
        public string CallKind   { get; set; }
        public string SendNumber { get; set; }
        public string SendName   { get; set; }
        public string Message    { get; set; }
        public string RegDate    { get; set; }
    }

    public class ResCMMessageSendLogList
    {
        public List<CMMessageSendLogModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ReqCMAdminList
    {
        public string AdminID          { get; set; }
        public string AppUseFlag       { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMAdminModel
    {
        public string AdminID          { get; set; }
        public string WebAlarmFlag     { get; set; }
        public string PCAlarmFlag      { get; set; }
        public string AutoPopupFlag    { get; set; }
        public string OrderViewFlag    { get; set; }
        public string CompanyViewFlag  { get; set; }
        public string PurchaseViewFlag { get; set; }
        public string SaleViewFlag     { get; set; }
        public string AppUseFlag       { get; set; }
        public string AppDeviceToken   { get; set; }
        public string AppDeviceModel   { get; set; }
        public string AppOSVersion     { get; set; }
        public string AppApiVerion     { get; set; }
        public string AppVersion       { get; set; }
        public string RegDate          { get; set; }
        public string UpdDate          { get; set; }
        public string AppMobileNo      { get; set; }
    }

    public class ResCMAdminList
    {
        public List<CMAdminModel> list      { get; set; }
        public int                RecordCnt { get; set; }
    }

    public class ReqCMLogList
    {
        public long   SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public int    CallType         { get; set; }
        public string CallKind         { get; set; }
        public string ChannelType      { get; set; }
        public string CallNumber       { get; set; }
        public string SendNumber       { get; set; }
        public string RcvNumber        { get; set; }
        public string Message          { get; set; }
        public string MyPhoneFlag      { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CMLogModel
    {
        public string SeqNo         { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public int    CallType      { get; set; }
        public string CallTypeM     { get; set; }
        public string CallKind      { get; set; }
        public string CallKindM     { get; set; }
        public string CallKindTypeM { get; set; }
        public string ChannelType   { get; set; }
        public string CallNumber    { get; set; }
        public string SendNumber    { get; set; }
        public string SendName      { get; set; }
        public string RcvNumber     { get; set; }
        public string RcvName       { get; set; }
        public string CallSessionID { get; set; }
        public string AuthID        { get; set; }
        public string RegYMD        { get; set; }
        public string Message       { get; set; }
        public string RegDate       { get; set; }
    }

    public class ResCMLogList
    {
        public List<CMLogModel> list      { get; set; }
        public int              RecordCnt { get; set; }
    }

    public class ReqCMMemoList
    {
        public int    SeqNo             { get; set; }
        public int    CenterCode        { get; set; }
        public string DateFrom          { get; set; }
        public string DateTo            { get; set; }
        public string CallNumber        { get; set; }
        public int    CallerType        { get; set; }
        public string CallerDetailTypes { get; set; }
        public string CompanyName       { get; set; }
        public string CompanyCeoName    { get; set; }
        public string CompanyChargeName { get; set; }
        public string CompanyMemo       { get; set; }
        public string AdminName         { get; set; }
        public string MyMemoFlag        { get; set; }
        public string AdminID           { get; set; }
        public string AccessCenterCode  { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }
    }

    public class CMMemoModel
    {
        public string SeqNo             { get; set; }
        public string CenterCode        { get; set; }
        public string CenterName        { get; set; }
        public string CallNumber        { get; set; }
        public string CallerType        { get; set; }
        public string CallerDetailType  { get; set; }
        public string CallerDetailText  { get; set; }
        public string CompanyName       { get; set; }
        public string CompanyCeoName    { get; set; }
        public string CompanyChargeName { get; set; }
        public string CompanyMemo       { get; set; }
        public string AdminID           { get; set; }
        public string AdminName         { get; set; }
        public string RegYMD            { get; set; }
        public string RegDate           { get; set; }
        public string DelAvailFlag      { get; set; }
    }

    public class ResCMMemoList
    {
        public List<CMMemoModel> list      { get; set; }
        public int               RecordCnt { get; set; }
    }

    public class ReqCMAdminMenuAccessChk
    {
        public string AdminID   { get; set; }
        public int    GradeCode { get; set; }
    }

    public class ResCMAdminMenuAccessChk
    {
        public string OrderViewFlag    { get; set; }
        public string SaleViewFlag     { get; set; }
        public string PurchaseViewFlag { get; set; }
        public string CompanyViewFlag  { get; set; }
    }

    public class ReqCMLogIns
    {
        public int    CenterCode    { get; set; }
        public int    CallType      { get; set; }
        public string CallKind      { get; set; }
        public string ChannelType   { get; set; }
        public string CallNumber    { get; set; }
        public string SendNumber    { get; set; }
        public string SendName      { get; set; }
        public string RcvNumber     { get; set; }
        public string RcvName       { get; set; }
        public string CallSessionID { get; set; }
        public string AuthID        { get; set; }
        public string Message       { get; set; }
    }

    public class ResCMLogIns
    {
        public string SeqNo      { get; set; }
        public int    CenterCode { get; set; }
    }
}