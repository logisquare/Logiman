using System;

namespace CommonLibrary.DasServices
{
    public class CargopassNotiOrder
    {
        // 등록/수정 정보
        public int    ProcType             { get; set; } // 처리타입(1:수정, 2:배차, 3:배차취소, 4:정보망 오더 취소)
        public string CenterCode           { get; set; } // 운송사코드
        public string CenterOrderNo        { get; set; } // 로지맨 오더번호(TOrderCargopass.CargopassOrderNo)
        public Int64  CPOrderNo            { get; set; } // 카고패스 오더번호
        public string NetworkOrdNo         { get; set; } // 화물번호(24시. OrdNo), 화물아이디(원콜, OrderId), 오더코드(화물맨, ORDERCODE, 업체오더번호)
        public string Network24DDID        { get; set; } // 전국24시콜화물 아이디
        public string NetworkHMMID         { get; set; } // 화물맨 아이디
        public string NetworkOneCallID     { get; set; } // 원콜 아이디
        public string NetworkHmadangID     { get; set; } // 화물마당 아이디
        public int    CargopassNetworkKind { get; set; } // 정보망 종류 (1 : 미선택, 2: 24시콜, 3: 화물맨, 4: 원콜)
        public string startWide            { get; set; } // 상차지 시/도(24시)
        public string startSgg             { get; set; } // 상차지 구/군(24시)
        public string startDong            { get; set; } // 상차지 읍/면/동(24시)
        public string startDetail          { get; set; } // 상차지 상세(24시)
        public string endWide              { get; set; } // 하차지 시/도(24시)
        public string endSgg               { get; set; } // 하차지 구/군(24시)
        public string endDong              { get; set; } // 하차지 읍/면/동(24시)
        public string endDetail            { get; set; } // 하차지 상세(24시)
        public string multiCargoGub        { get; set; } // 혼적여부(혼적)(24시), (독차/혼적)(원콜, MultiLoading), 독차구분(화물맨, LOADTYPE)
        public string urgent               { get; set; } // 긴급여부(긴급)(24시, 옵션), (일반, 긴급)(원콜, 옵션)
        public string shuttleCargoInfo     { get; set; } // 왕복여부(왕복)(24시, 옵션), (편도, 왕복)(원콜, RoundTrip, 필수)
        public string cargoTon             { get; set; } // 차량톤수(24시)
        public string truckType            { get; set; } // 차량종류(24시), 차종(원콜, VehicleType)
        public string frgton               { get; set; } // 적재중량(차량톤수의 110%까지)(24시), 화물중량(원콜, Weight), 화물실중량(화물맨, WEIGHT)
        public string startPlanDt          { get; set; } // 상차일(YYYYMMDD)(24시), 상차시간(화물맨, LOADAY, 일자+시분)
        public string StartPlanTm          { get; set; } // 상차시간(HH:MM) : 원콜 필수
        public string endPlanDt            { get; set; } // 하차일(YYYYMMDD)(24시), 하차시간(화물맨, DOWDAY, 일자+시분)
        public string EndPlanTm            { get; set; } // 하차시간(HH:MM) : 원콜 필수
        public string startLoad            { get; set; } // 상차방법(지게차,수작업,크레인, 호이스트 중 선택)(24시)
                                                         // 지게차, 수해줌, 수작업, 호이스트, 크레인(원콜, LoadingMethod, 옵션)
                                                         // 상차방법(화물맨, SATYPE)
        public string endLoad              { get; set; } // 하차방법(지게차,수작업,크레인, 호이스트 중 선택)(24시)
                                                         // 지게차, 수해줌, 수작업, 호이스트, 크레인(원콜, AlightMethod, 옵션)
                                                         // 하차벙법(화물맨, HATYPE)
        public string cargoDsc             { get; set; } // 화물상세내용(24시), 상품명(원콜, GoodName), 화물정보(화물맨, INFO)
        public string farePaytype          { get; set; } // 운송료 지불구분(선착불, 인수증, 카드 중 선택)(24시)
                                                         // 결제방법(인수증, 선불, 착불, 선착불, 카드)(원콜, FeePayType)
                                                         // 결제방식(화물맨, PAYMENT)

        public double fare              { get; set; } // 운송료(숫자만)(24시), 운임(원콜, TransportFee)
        public double fee               { get; set; } // 수수료(숫자만)(24시), 수수료(원콜, Commission)
        public string endAreaPhone      { get; set; } // 하차지 전화번호(24시(옵션))
        public string firstType         { get; set; } // 의뢰인구분(01,02 중 선택) * 01:일반화주, 02:주선/운송사(24시)
        public string firstShipperID    { get; set; } // 화주아이디(화물맨, OWID)
        public string firstShipperNm    { get; set; } // 원화주명(24시(옵션)), 화주명(화물맨, OWNAME)
        public string firstShipperInfo  { get; set; } // 원화주 전화번호(24시(옵션)), 화주 전화번호(화물맨, PHONE)
        public string firstShipperBizNo { get; set; } // 원화주 사업자번호(firstType이 01인 경우 필수)(24시(옵션))
        public string taxbillType       { get; set; } // 전자세금계산서 발행여부(Y)(24시(옵션))
        public string payPlanYmd        { get; set; } // 운송료지급예정일(YYYYMMDD)(24시)
        public string ConsignorName     { get; set; }
        public string Telephone         { get; set; }

        // 정보망 추가 정보
        public int    CPOrderStatus        { get; set; } // 화물상태(접수,완료등)(24시) // 카고패스 오더 상태(1 : 등록, 2 : 배차, 3 : 배차확정, 9 : 취소)
        public string ReceiptLoadDt        { get; set; } // 인수증 업로드 일시(24시)
        public string UnloadingDt          { get; set; } // 하차일시(24시)
        public string DriverName           { get; set; } // 차주명(24시, cjName)
        public string DriverBizName        { get; set; } // 차주 사업자명(화물맨)
        public string DriverBizNo          { get; set; } // 차주 사업자번호(24시, cjBizNo), (원콜, DriverBusinessNumber)
        public string DriverCell           { get; set; } // 차주 연락처(24시, cjPhone), (원콜, DriverTelephone)
        public string DriverCarNo          { get; set; } // 차주 차량번호(24시, cjCarNum), (원콜, VehicleNumber)
        public string DriverCarTon         { get; set; } // 차주 차량톤(24시, cjCargoTon), (원콜, DriverVehicleWeight)
        public string DriverCarType        { get; set; } // 차주 차량종류(24시, cjTruckType), (원콜, DriverVehicleType)
        public int    CorpCode             { get; set; } // 사업자과세구분코드(0:미확인,1:일반과세자,2:면세사업자,3:간이과세자)
        public string AdminID              { get; set; }
        public string AdminName            { get; set; }
    }

    public class CargopassNotiOrderDtl
    {
        // 24시 추가 정보
        public string cjTaxAmount { get; set; } // 차주 세금계산서 발행금액(24시)
        public string cjTaxDt     { get; set; } // 차주 세금계산서 발행일(24시)


        // 원콜 추가 정보
        public double LoadingLatitude  { get; set; } // 상차지 좌표 36.3333
        public double LoadingLongitude { get; set; } // 상차지 좌표 126.232
        public double AlightLatitude   { get; set; } // 하차지 좌표 35.232
        public double AlightLongitude  { get; set; } // 하차지 좌표 126.2343


        // 화물맨 추가 정보
        public double LOACODE  { get; set; } // 지역코드 (*필수)
        public double POIX     { get; set; } // 상차지 x좌표 (*필수)
        public double POIY     { get; set; } // 상차지 y좌표 (*필수)
        public double DOWCODE  { get; set; } // 지역코드 (*필수)
        public string POIX_OUT { get; set; } // 하차지 x좌표 (*필수)
        public string POIY_OUT { get; set; } // 하차지 y좌표 (*필수)
        public string ETC      { get; set; } // 기타사항
    }

    public class CargopassNotiDispatch
    {
        public int    ProcType      { get; set; } // 처리타입(1:수정, 2:배차, 3:배차취소, 4:정보망 오더 취소)
        public Int64  CPOrderNo     { get; set; } // 카고패스 오더번호
        public string NetworkOrdNo  { get; set; } // 화물번호(24시. OrdNo), 화물아이디(원콜, OrderId), 오더코드(화물맨, ORDERCODE, 업체오더번호)
        public string CenterCode    { get; set; } // 운송사코드
        public string CenterOrderNo { get; set; } // 로지맨 오더번호(TOrderCargopass.CargopassOrderNo)
        public string DriverName    { get; set; } // 차주명(24시, cjName)
        public string DriverBizNo   { get; set; } // 차주 사업자번호(24시, cjBizNo), (원콜, DriverBusinessNumber)
        public string DriverCell    { get; set; } // 차주 연락처(24시, cjPhone), (원콜, DriverTelephone)
        public string DriverCarNo   { get; set; } // 차주 차량번호(24시, cjCarNum), (원콜, VehicleNumber)
        public string DriverCarTon  { get; set; } // 차주 차량톤(24시, cjCargoTon), (원콜, DriverVehicleWeight)
        public string DriverCarType { get; set; } // 차주 차량종류(24시, cjTruckType), (원콜, DriverVehicleType)
    }

    public class CargopassNotiDispatchCnl
    {
        public int    ProcType      { get; set; } // 처리타입(1:수정, 2:배차, 3:배차취소, 4:정보망 오더 취소)
        public string CenterCode    { get; set; } // 운송사코드
        public string CenterOrderNo { get; set; } // 로지맨 오더번호(TOrderCargopass.CargopassOrderNo)
    }

    public class CargopassNotiOrderCnl
    {
        public int    ProcType      { get; set; } // 처리타입(1:수정, 2:배차, 3:배차취소, 4:정보망 오더 취소)
        public string CenterCode    { get; set; } // 운송사코드
        public string CenterOrderNo { get; set; } // 로지맨 오더번호(TOrderCargopass.CargopassOrderNo)
    }
}