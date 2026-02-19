using CommonLibrary.Constants;
using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class CenterSessionInfo
    {
        public bool   IsLogin           { get; set; }
        public string SessionKey        { get; set; } = string.Empty;
        public int    SiteCode          { get; set; } = 0;
        public string CenterCode        { get; set; } = string.Empty;
        public string CenterName        { get; set; } = string.Empty;
        public string AdminID           { get; set; } = string.Empty;
        public string AdminName         { get; set; } = string.Empty;
        public string LoginIP           { get; set; } = string.Empty;
        public string Network24DDID     { get; set; } = string.Empty;
        public string NetworkHMMID      { get; set; } = string.Empty;
        public string NetworkOneCallID  { get; set; } = string.Empty;
        public string NetworkHmadangID  { get; set; } = string.Empty;
        public string MobileNo          { get; set; } = string.Empty;
        public string TelNo             { get; set; } = string.Empty;
        public string Email             { get; set; } = string.Empty;
        public string DeptName          { get; set; } = string.Empty;
        public string Position          { get; set; } = string.Empty;
        public string PageTitleViewFlag { get; set; } = "Y";
        public string AccessCenterCode  { get; set; } = string.Empty;
        public string TimeStamp         { get; set; } = string.Empty;
    }

    public class CenterOrderInfo
    {
        public string ViewFlag         { get; set; } = "N"; // 상세보기 여부 (리스트에서 열거나 수정없이 상세보기를 하는 경우 Y)
        public int    SiteCode         { get; set; } = CommonConstant.SITE_CODE; // 사이트 구분 코드 (1)
        public string CenterOrderNo    { get; set; } // 로지맨 오더번호(TOrderCargopass.CargopassOrderNo)
        public string CenterCode       { get; set; } // 회원사코드
        public string CenterName       { get; set; } // 회원사명
        public string ConsignorName    { get; set; } = string.Empty; // 화주명 
        public string StartAddr        { get; set; } // 상차지
        public string StartDetail      { get; set; } // 상차지 상세
        public string EndAddr           { get; set; } // 하차지
        public string EndDetail        { get; set; } // 하차지 상세
        public string MultiCargoGub    { get; set; } // 혼적여부(혼적)(24시), (독차/혼적)(원콜, MultiLoading), 독차구분(화물맨, LOADTYPE)
        public string Urgent           { get; set; } // 긴급여부(긴급)(24시, 옵션), (일반, 긴급)(원콜, 옵션)
        public string ShuttleCargoInfo { get; set; } // 왕복여부(왕복)(24시, 옵션), (편도, 왕복)(원콜, RoundTrip, 필수)
        public string CargoTon         { get; set; } // 차량톤수(24시)
        public string TruckType        { get; set; } // 차량종류(24시), 차종(원콜, VehicleType)
        public string FrgTon           { get; set; } // 적재중량(차량톤수의 110%까지)(24시), 화물중량(원콜, Weight), 화물실중량(화물맨, WEIGHT)
        public string StartPlanDT      { get; set; } // 상차일(YYYYMMDD)(24시), 상차시간(화물맨, LOADAY, 일자+시분)
        public string StartPlanTm      { get; set; } // 상차시간(HH:MM) : 원콜 필수
        public string EndPlanDT        { get; set; } // 하차일(YYYYMMDD)(24시), 하차시간(화물맨, DOWDAY, 일자+시분)
        public string EndPlanTm        { get; set; } // 하차시간(HH:MM) : 원콜 필수
        public string StartLoad        { get; set; } // 상차방법(지게차,수작업,크레인, 호이스트 중 선택)(24시) // 지게차, 수해줌, 수작업, 호이스트, 크레인(원콜, LoadingMethod, 옵션) // 상차방법(화물맨, SATYPE)
        public string EndLoad          { get; set; } // 하차방법(지게차,수작업,크레인, 호이스트 중 선택)(24시) // 지게차, 수해줌, 수작업, 호이스트, 크레인(원콜, AlightMethod, 옵션) // 하차벙법(화물맨, HATYPE)
        public string EndAreaPhone     { get; set; } // 하차지 전화번호(24시(옵션))
        public string CargoDsc         { get; set; } // 화물상세내용(24시), 상품명(원콜, GoodName), 화물정보(화물맨, INFO)
        public string FarePayType      { get; set; } = "인수증"; // 운송료 지불구분(선착불, 인수증, 카드 중 선택)(24시) // 결제방법(인수증, 선불, 착불, 선착불, 카드)(원콜, FeePayType) // 결제방식(화물맨, PAYMENT)
        public string Fare             { get; set; } = "0"; // 운송료(숫자만)(24시), 운임(원콜, TransportFee)
        public string Fee              { get; set; } = "0"; // 수수료(숫자만)(24시), 수수료(원콜, Commission)
        public string PayPlanYmd       { get; set; } = string.Empty; // 운송료지급예정일(YYYYMMDD)(24시)
        public string TaxBillType      { get; set; } = "Y"; // 전자세금계산서 발행여부(Y)(24시(옵션))
        public string Telephone        { get; set; } = string.Empty; // 담당자연락처
        public string TimeStamp        { get; set; } = string.Empty;
    }

    public class CenterPageOption
    {
        public int    PageType          { get; set; } = 1; // 페이지 형태 1 : POPUP, 2 : FRAME
        public string PageTitleViewFlag { get; set; } = "Y";
        public string PageErrRetUrl     { get; set; } = "";
        public int    PageWidth         { get; set; } = 0;
        public int    PageHeight        { get; set; } = 0;
    }

    public class CargopassModel
    {
        public long   CargopassOrderNo { get; set; }
        public int    CenterCode       { get; set; }
        public int    DispatchType     { get; set; }
        public string OrderNos         { get; set; }
        public string ConsignorName    { get; set; }
        public string PickupYMD        { get; set; }
        public string PickupHM         { get; set; }
        public string PickupAddr       { get; set; }
        public string PickupAddrDtl    { get; set; }
        public string PickupWay        { get; set; }
        public string GetYMD           { get; set; }
        public string GetHM            { get; set; }
        public string GetAddr          { get; set; }
        public string GetAddrDtl       { get; set; }
        public string GetWay           { get; set; }
        public string GetTelNo         { get; set; }
        public double Weight           { get; set; }
        public int    Volume           { get; set; }
        public double CBM              { get; set; }
        public string CarTon           { get; set; }
        public string CarTruck         { get; set; }
        public int    QuickType        { get; set; }
        public string PayPlanYMD       { get; set; }
        public double SupplyAmt        { get; set; }
        public string LayerFlag        { get; set; }
        public string UrgentFlag       { get; set; }
        public string ShuttleFlag      { get; set; }
        public string Note             { get; set; }
        public string Network24DDID    { get; set; }
        public string NetworkHMMID     { get; set; }
        public string NetworkOneCallID { get; set; }
        public string NetworkHmadangID { get; set; }
        public string TelNo            { get; set; }
        public string RegAdminID       { get; set; }
        public string RegAdminName     { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
    }

    public class CargopassGridModel
    {
        public string CargopassOrderNo      { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public int    DispatchType          { get; set; }
        public string DispatchTypeM         { get; set; }
        public string ConsignorName         { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupHM              { get; set; }
        public string PickupAddr            { get; set; }
        public string PickupAddrDtl         { get; set; }
        public string PickupWay             { get; set; }
        public string GetYMD                { get; set; }
        public string GetHM                 { get; set; }
        public string GetAddr               { get; set; }
        public string GetAddrDtl            { get; set; }
        public string GetWay                { get; set; }
        public string GetTelNo              { get; set; }
        public double Weight                { get; set; }
        public int    Volume                { get; set; }
        public double CBM                   { get; set; }
        public string CarTon                { get; set; }
        public string CarTruck              { get; set; }
        public int    QuickType             { get; set; }
        public string QuickTypeM            { get; set; }
        public string PayPlanYMD            { get; set; }
        public double SupplyAmt             { get; set; }
        public string LayerFlag             { get; set; }
        public string UrgentFlag            { get; set; }
        public string ShuttleFlag           { get; set; }
        public string Note                  { get; set; }
        public int    CargopassNetworkKind  { get; set; }
        public string CargopassNetworkKindM { get; set; }
        public string ComName               { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public int    DispatchCnt           { get; set; }
        public string Network24DDID         { get; set; }
        public string NetworkHMMID          { get; set; }
        public string NetworkOneCallID      { get; set; }
        public string NetworkHmadangID      { get; set; }
        public string TelNo                 { get; set; }
        public int    CargopassStatus       { get; set; }
        public string CargopassStatusM      { get; set; }
        public string RegAdminID            { get; set; }
        public string RegAdminName          { get; set; }
        public string RegYMD                { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdAdminName          { get; set; }
        public string UpdDate               { get; set; }
        public string CnlAdminID            { get; set; }
        public string CnlAdminName          { get; set; }
        public string CnlDate               { get; set; }
        public string OrderNo               { get; set; }
    }

    public class ReqCargopassList
    {
        public long   CargopassOrderNo  { get; set; }
        public int    CenterCode        { get; set; }
        public int    DateType          { get; set; }
        public string DateFrom          { get; set; }
        public string DateTo            { get; set; }
        public string ComCorpNo         { get; set; }
        public string CarNo             { get; set; }
        public string DriverName        { get; set; }
        public string DriverCell        { get; set; }
        public long   OrderNo           { get; set; }
        public string CargopassStatuses { get; set; }
        public string MyOrderFlag       { get; set; }
        public string RegAdminID        { get; set; }
        public string RegAdminName      { get; set; }
        public string AccessCenterCode  { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }
    }

    public class ResCargopassList
    {
        public List<CargopassGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class ReqCargopassOrderPlaceList
    {
        public long   CargopassOrderNo { get; set; }
        public int    CenterCode       { get; set; }
        public string OrderNos         { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class CargopassOrderPlaceGridModel
    {
        public int    PGType        { get; set; }
        public string PGTypeM       { get; set; }
        public string ConsignorName { get; set; }
        public string YMD           { get; set; }
        public string HM            { get; set; }
        public string Place         { get; set; }
        public string Addr          { get; set; }
        public string AddrDtl       { get; set; }
        public string Way           { get; set; }
        public string TelNo         { get; set; }
    }

    public class ResCargopassOrderPlaceList
    {
        public List<CargopassOrderPlaceGridModel> list      { get; set; }
        public int                                OrderCnt  { get; set; }
        public int                                Volume    { get; set; }
        public double                             CBM       { get; set; }
        public int                                Weight    { get; set; }
        public int                                RecordCnt { get; set; }
        public string                             CarTon    { get; set; }
        public string                             CarTruck  { get; set; }
    }

}