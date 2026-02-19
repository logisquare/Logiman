using CommonLibrary.DasServices;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;

//===============================================================
// FileName       : CommonModel.cs
// Description    : 공통 모델 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModel
{
    public class ResponseCommon
    {
        public int    RetCode  { get; set; }
        public string ErrMsg   { get; set; }
        public Int64  APISeqNo { get; set; }
    }

    public class HeaderCommon
    {
        public Int64  APISeqNo      { get; set; }
        public int    ResultCode    { get; set; }
        public string ResultMessage { get; set; }
    }

    public class ReqSendSMS
    {
        public int    CenterCode { get; set; }
        public string Sender     { get; set; }
        public string SendTo     { get; set; }
        public string Message    { get; set; }
    }

    public class ResSendSMS
    {
        public HeaderCommon Header = new HeaderCommon();
    }

    public class ReqSMSAuth
    {
        public int    CenterCode { get; set; }
        public string Sender     { get; set; }
        public string SendTo     { get; set; }
    }

    public class ResSMSAuth_Res
    {
        public string receiptNum { get; set; }
        public string EncSMSAuthNum { get; set; }
        public string SendNum { get; set; }
        public string RcvNum { get; set; }
        public int MsgType { get; set; }
        public int TemplateSeqNo { get; set; }
        public string Title { get; set; }
        public string Contents { get; set; }
    }

    public class ResSMSAuth
    {
        public HeaderCommon Header = new HeaderCommon();
        public ResSMSAuth_Res Payload = new ResSMSAuth_Res();
    }

    public class ReqChkCorpNo
    {
        public string CorpNo { get; set; }
    }

    public class PayloadChkCorpNo
    {
        public string CorpNo         { get; set; }
        public int    ServiceCode    { get; set; }
        public string ServiceCodeMsg { get; set; }
        public int    CorpCode       { get; set; }
        public string CorpCodeMsg    { get; set; }
        public string CloseDate      { get; set; }
        public string ChangeDate     { get; set; }
        public string CorpChkYMD     { get; set; }
        public int    ExistsFlag     { get; set; }
        public int    HttpStatusCode { get; set; }
        public string HttpStatusMsg  { get; set; }
    }

    public class ResChkCorpNo
    {
        public HeaderCommon     Header  = new HeaderCommon();
        public PayloadChkCorpNo Payload = new PayloadChkCorpNo();
    }

    public class ReqChkCenterExists
    {
        public string CorpNo { get; set; }
    }

    public class PayloadChkCenterExists
    {
        public string ExistsFlag { get; set; }
        public int    OrderType  { get; set; }
        public int    CenterCode { get; set; }
        public string CenterName { get; set; }
        public string CenterID   { get; set; }
        public string CenterKey  { get; set; }
    }

    public class ResChkCenterExists
    {
        public HeaderCommon           Header  = new HeaderCommon();
        public PayloadChkCenterExists Payload = new PayloadChkCenterExists();
    }

    public class ReqGetAcctRealName
    {
        public string BankCode { get; set; }
        public string AcctNo   { get; set; }
        public string CorpNo   { get; set; }
    }

    public class PayloadGetAcctRealName
    {
        public int    SeqNo        { get; set; }
        public string BankCode     { get; set; }
        public string AcctNo       { get; set; }
        public string AcctName     { get; set; }
        public string CorpNo       { get; set; }
        public string CeoName      { get; set; }
        public string EncAcctNo    { get; set; }
        public string SearchAcctNo { get; set; }
        public int    ExistsFlag   { get; set; }
        public string PgResCode    { get; set; }
        public string PgResMsg     { get; set; }
    }

    public class ResGetAcctRealName
    {
        public HeaderCommon           Header  = new HeaderCommon();
        public PayloadGetAcctRealName Payload = new PayloadGetAcctRealName();
    }

    public class ReqInsCenter : CenterViewModel
    {
    }

    public class PayloadInsCenter
    {
        public int    CenterCode { get; set; }
        public string CenterID   { get; set; }
        public string CenterKey  { get; set; }
    }

    public class ResInsCenter
    {
        public HeaderCommon     Header  = new HeaderCommon();
        public PayloadInsCenter Payload = new PayloadInsCenter();
    }

    public class ReqUpdCenter : CenterViewModel
    {
    }

    public class ResUpdCenter
    {
        public HeaderCommon Header = new HeaderCommon();
    }

    public class RestDataTableToJsonRslt
    {
        public int             RetCode    { get; set; }
        public string          ErrMsg     { get; set; }
        public int             ListCount  { get; set; }
        public int             TotalCount { get; set; }
        public List<Hashtable> List       { get; set; }
    }

    public class ReqInsOrderTMS
    {
        public int    CenterCode   { get; set; } //(integer): 운송사코드
        public string CenterID     { get; set; } //(string): 운송사ID
        public string CenterKey    { get; set; } //(string): 운송사KEY
        public double SendCost     { get; set; } //(number): 실제 송금액 (운송료에서 공제액 차감한 금액)
        public double SupplyCost   { get; set; } //(number): 공급가액
        public double TaxCost      { get; set; } //(number): 부가세
        public int    PayWay       { get; set; } //(integer): 지불방법 (1:일반결제, 2:빠른입금 (차), 3:빠른입금(운))
        public double CarPay       { get; set; } //(number): 운송료
        public string CarName      { get; set; } //(string, optional): 차주 사업자명
        public string CarBizNo     { get; set; } //(string): 차주 사업자번호
        public string CarCeo       { get; set; } //(string, optional): 차주 사업자 대표자명
        public string CarBankCode  { get; set; } //(string): 입금 은행코드
        public string CarBankName  { get; set; } //(string, optional): 입금 은행명
        public string CarAcctName  { get; set; } //(string): 계좌주명
        public string CarAcctNo    { get; set; } //(string): 계좌번호
        public string CarNo        { get; set; } //(string, optional): 차량번호
        public string CarDriName   { get; set; } //(string, optional): 차주 명
        public string CarDriCell   { get; set; } //(string, optional): 차주 휴대폰번호
        public string TaxReceive   { get; set; } //(string, optional): 계산서 수신여부 (Y/N), 미입력시 Y
        public string ProcessFlag  { get; set; } //(string, optional)
        public string ClosingSeqNo { get; set; } //(string): 운송료 마감번호
        public string IssueDate    { get; set; } //(string, optional): 계산서 작성일 8자리(YYYYMMDD)
        public string PayPlanDate  { get; set; } //(string): 송금 예정일 8자리 (YYYYMMDD)
        public string Note         { get; set; } //(string, optional): 비고
        public string PartnerFlag  { get; set; } //(string, optional): 협럭사여부 (Y/N), 미입력시 N
        public int    PayKind      { get; set; } //(integer, optional): 송금유형상세 (1:일반,4:포인트사용)
        public double UsedPoint    { get; set; } //(number, optional): 포인트 사용 금액
        public double ReconcAmt    { get; set; } //(number, optional): 대사금액 (검증)

        public ReqInsOrderTMS()
        {
            CenterID    = string.Empty;
            CenterKey   = string.Empty;
            CarName     = string.Empty;
            CarCeo      = string.Empty;
            CarBankName = string.Empty;
            CarNo       = string.Empty;
            CarDriName  = string.Empty;
            CarDriCell  = string.Empty;
            TaxReceive  = "Y";
            ProcessFlag = string.Empty;
            IssueDate   = string.Empty;
            Note        = string.Empty;
            PartnerFlag = "N";
        }
    }

    public class PayloadInsOrderTMS
    {
        public string OrderNo      { get; set; }
        public int    CenterCode   { get; set; }
        public string ClosingSeqNo { get; set; }
        public int    PaySendType  { get; set; }
        public string OrgPayYMD    { get; set; }
        public string PayYMD       { get; set; }
        public string SendYMD      { get; set; }
        public double SendFee      { get; set; }
        public double SendAmt      { get; set; }
        public double SendFeeRate  { get; set; }
        public int    PayStatus    { get; set; }
        public string ExistsFlag   { get; set; }
    }

    public class ResInsOrderTMS
    {
        public HeaderCommon       Header  = new HeaderCommon();
        public PayloadInsOrderTMS Payload = new PayloadInsOrderTMS();
    }

    public class ReqUpdOrderDirect
    {
        public int    CenterCode   { get; set; } //(integer): 운송사코드
        public string CenterID     { get; set; } //(string): 운송사ID
        public string CenterKey    { get; set; } //(string): 운송사KEY
        public string OrderNo      { get; set; } //(string): 오더번호
        public string ClosingSeqNo { get; set; } //(string): 운송료 마감번호
        public string PartnerFlag  { get; set; } //(string, optional): 협럭사여부(Y/N), 미입력시 N
        public string CarDriCell   { get; set; } //(string, optional): 차주 휴대폰번호
        public int    PayKind      { get; set; } //(integer, optional): 송금유형상세(1:일반,4:포인트사용)
        public double UsedPoint    { get; set; } //(number, optional): 포인트 사용 금액
        public double ReconcAmt    { get; set; } //(number, optional): 대사금액(검증)

        public ReqUpdOrderDirect()
        {
            CenterID    = string.Empty;
            CenterKey   = string.Empty;
            OrderNo     = string.Empty;
            PartnerFlag = "N";
            CarDriCell  = string.Empty;
            PayKind     = 1;
            UsedPoint   = 0;
        }
    }

    public class ResUpdOrderDirect
    {
        public HeaderCommon Header = new HeaderCommon();
    }

    public class ReqUpdOrderDirectCompany
    {
        public int    CenterCode   { get; set; } //(integer): 운송사코드
        public string CenterID     { get; set; } //(string): 운송사ID
        public string CenterKey    { get; set; } //(string): 운송사KEY
        public string OrderNo      { get; set; } //(string): 오더번호
        public string ClosingSeqNo { get; set; } //(string): 운송료 마감번호
        public string PartnerFlag  { get; set; } //(string, optional): 협럭사여부(Y/N), 미입력시 N
        public string CarDriCell   { get; set; } //(string, optional): 차주 휴대폰번호
        public int    PayKind      { get; set; } //(integer, optional): 송금유형상세(1:일반,4:포인트사용)
        public double UsedPoint    { get; set; } //(number, optional): 포인트 사용 금액
        public double ReconcAmt    { get; set; } //(number, optional): 대사금액(검증)

        public ReqUpdOrderDirectCompany()
        {
            CenterID    = string.Empty;
            CenterKey   = string.Empty;
            OrderNo     = string.Empty;
            PartnerFlag = "N";
            CarDriCell  = string.Empty;
        }
    }

    public class ResUpdOrderDirectCompany
    {
        public HeaderCommon Header = new HeaderCommon();
    }

    public class ReqGetCenterOrderChk
    {
        public int    CenterCode   { get; set; } //(integer): 운송사코드
        public string CenterID     { get; set; } //(string): 운송사ID
        public string CenterKey    { get; set; } //(string): 운송사KEY
        public string ClosingSeqNo { get; set; } //(string):  마감번호(전표번호)

        public ReqGetCenterOrderChk()
        {
            CenterID  = string.Empty;
            CenterKey = string.Empty;
        }
    }

    public class PayloadGetCenterOrderChk
    {
        public long    OrderNo      { get; set; } //(integer): 오더번호
        public int    CenterCode   { get; set; } //(integer): 운송사코드
        public string ClosingSeqNo { get; set; } //(string): 마감번호
        public int    PaySendType  { get; set; } //(integer): 결제유형(1:일반결제, 2:즉시결제, 3:바로결제(착불))
        public string OrgPayYmd { get; set; } //(string): 최초 결제 요청일(결제대기 상태에서는 NULL, 담당자가 결제요청일을 설정, 즉시송금으로 바뀌어도 이 값은 유지됨)
        public string PayYmd { get; set; } //(string): 결제 요청일(결제대기 상태에서는 NULL, 담당자가 결제요청일을 설정)
        public string SendYmd { get; set; } //(string): 송금 완료일
        public double SendFee { get; set; } //(number): 차주 송금수수료(로지스랩 송금수익)
        public double SendAmt { get; set; } //(number): 최종 송금액(SendAmt = PayAmt-SendFee)
        public double SendFeeRate { get; set; } //(number): 송금 수수료율
        public double CenterFee { get; set; } //(number): 회원사 수수료(빠른입금(운). 로지스랩 정산수익)
        public double CenterFeeRate { get; set; } //(number): 회원사 빠른입금(운) 수수료율
        public int    PayKind { get; set; } //(integer): 운송료 결제 방법(1:계좌송금, 2:운송사카드결제, 3:빠(운) 14일, 4:머핀포인트사용)
        public int    UsedPoint { get; set; } //(number): 사용포인트
        public int    PayStatus { get; set; } //(integer): 결제상태(1:결제대기,2:결제확인(담당자),3:결제승인(결제권자),4:결제완료, 5:송금완료, 6:송금취소)
        public string ExistsFlag { get; set; } //(string): 오더 존재여부(Y/N)
    }

    public class ResGetCenterOrderChk
    {
        public HeaderCommon             Header  = new HeaderCommon();
        public PayloadGetCenterOrderChk Payload = new PayloadGetCenterOrderChk();
    }


    public class ReqGetCenterSendFeeD
    {
        public int    CenterCode { get; set; } //(integer): 운송사코드
        public string CenterID   { get; set; } //(string): 운송사ID
        public string CenterKey  { get; set; } //(string): 운송사KEY
        public string CarDriCell { get; set; } //(string): 차주 연락처
        public double PayAmt     { get; set; } // (number): 송금액
        public string PayYMD     { get; set; } //(string): 송금예정일
        public string ExcludeVat { get; set; } //(string, optional): 반환 금액의 부가세포함여부(Y/N)

        public ReqGetCenterSendFeeD()
        {
            CenterID   = string.Empty;
            CenterKey  = string.Empty;
            ExcludeVat = "N";
        }
    }

    public class PayloadGetCenterSendFeeD
    {
        public int    CenterCode         { get; set; } //(integer): 운송사코드
        public string CenterID           { get; set; } //(string): 운송사ID
        public string CenterKey          { get; set; } //(string): 운송사KEY
        public int    SendSettleKind     { get; set; } //(integer): 1:고정률,2:일할
        public double SendFeeRateNormal  { get; set; } //(number): 일반차주 수수료율
        public double SendFeeNormal      { get; set; } //(number): 일반차주 수수료금액
        public double SendAmtNormal      { get; set; } //(number): 일반차주 송금액
        public double SendFeeRatePeriod  { get; set; } //(number): 앱회원 수수료율
        public double SendFeePeriod      { get; set; } //(number): 앱회원 수수료금액
        public double SendAmtPeriod      { get; set; } //(number): 앱회원 송금액
        public double SendFeeRatePartner { get; set; } //(number): 협력사 수수료율
        public double SendFeePartner     { get; set; } //(number): 협력사 수수료금액
        public double SendAmtPartner     { get; set; } //(number): 협력사 송금액
        public string ExistsFlag         { get; set; } //(string): 앱회원 가입여부(Y/N)
    }

    public class ResGetCenterSendFeeD
    {
        public HeaderCommon             Header  = new HeaderCommon();
        public PayloadGetCenterSendFeeD Payload = new PayloadGetCenterSendFeeD();
    }

    public class ReqGetCardAgreeInfo
    {
        public string CorpNo { get; set; } //사업자번호
    }

    public class PayloadGetCardAgreeInfo
    {
        public string AuthTel       { get; set; } //인증된 휴대폰번호
        public string CardAgreeFlag { get; set; } //카드동의여부(Y/N)
        public string CardAgreeYmd  { get; set; } //카드동의일자
        public string CardAgreeDay  { get; set; } //동의후 지난일수
        public string RegDate       { get; set; } //등록일시
        public string UpdDate       { get; set; } //수정일시
        public string ExistsFlag    { get; set; } //동의정보 존재여부(Y/N)
    }

    public class ResGetCardAgreeInfo
    {
        public HeaderCommon            Header  = new HeaderCommon();
        public PayloadGetCardAgreeInfo Payload = new PayloadGetCardAgreeInfo();
    }

    public class ReqUpdCardAgreeInfo
    {
        public int    CenterCode    { get; set; } //운송사코드
        public string CenterID      { get; set; } //운송사ID
        public string CenterKey     { get; set; } //운송사KEY
        public string CorpNo        { get; set; } //사업자번호
        public string AuthTel       { get; set; } //휴대폰번호
        public string CardAgreeFlag { get; set; } //동의FLAG(Y/N)
        public string AdminID       { get; set; } //관리자 아이디

        public ReqUpdCardAgreeInfo()
        {
            CenterID  = string.Empty;
            CenterKey = string.Empty;
            AdminID   = string.Empty;
        }
    }
    public class PayloadUpdCardAgreeInfo
    {
        public string CardAgreeYmd  { get; set; } //카드동의일자
    }

    public class ResUpdCardAgreeInfo
    {
        public HeaderCommon            Header  = new HeaderCommon();
        public PayloadUpdCardAgreeInfo Payload = new PayloadUpdCardAgreeInfo();
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 구글 OTP CODE
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqGoogleOTPKeyGen
    {
        public string Issuer    { get; set; } // 발행 식별자(도메인 등)
        public string AccountID { get; set; } // 계정이름(아이디)
        public string SecretKey { get; set; } // Secret Key (외부에 노출되지 않게 관리) ,
        public int    QrPixel   { get; set; } // 생성 QR코드 Pixel (Default : 300)
    }
    public class ResGoogleOTPKeyGen
    {
        public HeaderCommon              Header  = new HeaderCommon();
        public ResGoogleOTPKeyGenPayload Payload = new ResGoogleOTPKeyGenPayload();
    }
    public class ResGoogleOTPKeyGenPayload
    {
        public string ManualEntryKey      { get; set; } // 설정 키
        public string QrCodeSetupImageUrl { get; set; } // QR 코드 스캔 이미지 데이터
    }

    public class ReqGoogleOTPAuth
    {
        public string AccountID  { get; set; } // 계정 아이디
        public string SecretKey  { get; set; } // Secret Key (외부에 노출되지 않게 관리)
        public string TokenValue { get; set; } //구글인증 토근값 6자리
    }

    public class ResGoogleOTPAuth
    {
        public HeaderCommon            Header  = new HeaderCommon();
        public ResGoogleOTPAuthPayload Payload = new ResGoogleOTPAuthPayload();
    }
    public class ResGoogleOTPAuthPayload
    {
        public bool isValid { get; set; } // 인증성공여부
    }

    /// <summary>
    /// 결과 데이터를 저장하는 Map Object
    /// 마지막에 JSON String으로 출력한다
    /// </summary>
    ///
    public class ResponseMap
    {
        //공통 멤버 변수
        public int    RetCode   { get; set; }
        public string ErrMsg    { get; set; }
        public string DevErrMsg { get; set; }

        public string strResponse = string.Empty;

        //추가 데이타를 담기 위한 Dictionary
        readonly Dictionary<String, Object> dic               = null;
        readonly JavaScriptSerializer       objJsonSerializer = null;

        /// <summary>
        /// 생성자
        /// </summary>
        public ResponseMap()
        {
            //초기화
            dic               = new Dictionary<string, object>();
            objJsonSerializer = new JavaScriptSerializer();
        }

        /// <summary>
        /// Dictionary 데이터 저장
        /// </summary>
        /// <param name="key">key</param>
        /// <param name="obj">value</param>
        public void Add(String key, Object obj)
        {
            dic.Add(key, obj);
        }

        /// <summary>
        /// Dictionary 데이터 삭제
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Remove(String key)
        {
            return dic.Remove(key);
        }

        /// <summary>
        /// Dictionary 초기화
        /// </summary>
        public void Clear()
        {
            dic.Clear();
        }

        /// <summary>
        /// Dictionary 데이터 조회
        /// </summary>
        /// <param name="key">key</param>
        /// <returns></returns>
        public Object Get(String key)
        {
            return dic[key];
        }


        /// <summary>
        /// Dictionary 에 저장된 데이터를 Json String 으로 변환한다
        /// - 에러코드와 에러메시지도 함께 담는다 (this.intRetval, this.strErrMsg)
        /// </summary>
        /// <returns></returns>
        public string ToJsonString()
        {
            string lo_strSerialize       = string.Empty;
            string lo_strContentTypeJson = "application/json";

            //strResponse가 있으면 리턴
            if (!string.IsNullOrEmpty(strResponse))
            {
                return strResponse;
            }

            // 설정된 contexttype이 JSON 출력이 아닌 경우 null 반환 (파일다운로드 처리로직)
            if (!HttpContext.Current.Response.ContentType.Equals(lo_strContentTypeJson))
            {
                return null;
            }

            //익셉션 발생시에는 공통 메시지
            dic.Add("ErrMsg", RetCode < 0 ? "Exception Error" : ErrMsg);
            dic.Add("RetCode", RetCode);

            lo_strSerialize = "[" + objJsonSerializer.Serialize(dic) + "]";

            return lo_strSerialize;
        }
    }

    ///-------------------------------------
    /// <summary>
    /// 에러 데이터
    /// </summary>
    ///-------------------------------------
    public class ErrResult
    {
        public int    ErrorCode    { get; set; }
        public string ErrorMsg     { get; set; }
        public int    DevErrorCode { get; set; }
        public string DevErrorMsg  { get; set; }
        public string ReturnUrl    { get; set; }

        public ErrResult()
        {
            ErrorCode    = 0;
            DevErrorCode = 0;
        }

        public ErrResult(int intRetVal, string strErrMsg)
        {
            ErrorCode = intRetVal;
            ErrorMsg  = strErrMsg;
        }

        public ErrResult(int intRetVal, string strErrMsg, int intDetailRetVal, string strDetailErrMsg)
        {
            ErrorCode    = intRetVal;
            ErrorMsg     = strErrMsg;
            DevErrorCode = intDetailRetVal;
            DevErrorMsg  = strDetailErrMsg;
        }
    }

    public class APIResCommon
    {
        public int    RetCode   { get; set; }
        public string ErrMsg    { get; set; }
        public string DevErrMsg { get; set; }
    }

    /// <summary>
    /// 공통 응답 처리
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class ServiceResult<T>
    {
        /// <summary>
        /// 성공 응답
        /// </summary>
        public T data { get; set; }

        public ErrResult result { get; set; }

        public ServiceResult()
        {
            result = new ErrResult();
        }

        public ServiceResult(T t)
        {
            data   = t;
            result = new ErrResult();
        }

        public ServiceResult(int code_, string message_ = null, int detailCode_ = 0, string detail_ = null)
        {
            SetResult(code_, message_, detailCode_, detail_);
        }

        internal void SetResult(int code_, string message_ = null, int detailCode_ = 0, string detail_ = null)
        {
            result = new ErrResult(code_, message_, detailCode_, detail_);
        }
    }


    public class ErrorResponse
    {
        public ErrResult result { get; set; }
        public ErrorResponse()
        {
            result = new ErrResult();
        }
    }

    public class ReqContactInfo
    {
        public string in_str    { get; set; }
        public string force_map { get; set; } = "N"; //우편번호api(네이버) 강제 호출 유무 ( Y / N)
        public string map_cache { get; set; } = "Y"; //우편번호api 호출시 추가 호출없이 전에 받은값 보여주기 (Y / N)
    }


    public class ResContactInfo
    {
        public int        ResultCode    { get; set; }
        public string     ResultMessage { get; set; }
        public ResultBody ResultBody    { get; set; }
    }

    public class ResultBody
    {
        public Address       Address { get; set; }
        public List<Manager> Manager { get; set; }

    }

    public class Address
    {
        public string     InAddress  { get; set; }
        public OutAddress OutAddress { get; set; }

    }

    public class OutAddress
    {
        public string NeedCheck     { get; set; }
        public string AddressMain   { get; set; }
        public string AddressDetail { get; set; }
        public string AddressFull   { get; set; }
        public string AddressDong   { get; set; }
        public string ZipCode       { get; set; }
        public string RegionCode    { get; set; }
        public string RegionName    { get; set; }
        public double CoordX        { get; set; } = 0;
        public double CoordY        { get; set; } = 0;
        public string IsCache       { get; set; }
    }

    public class Manager
    {
        public string Name   { get; set; }
        public string Sir    { get; set; }
        public string Mobile { get; set; }
        public string Office { get; set; }
        public string Ext    { get; set; }
    }

    public class CheckIPNation_Request
    {
        public string IPAddress     { get; set; }
    }

    public class CheckIPNation_Res
    {
        public string Exist       { get; set; }
        public int    SeqNo       { get; set; }
        public string IPAddress   { get; set; }
        public string Registry    { get; set; }
        public string CountryCode { get; set; }
        public string AccessFlag  { get; set; }
        public string AccessDesc  { get; set; }
        public string RegDate     { get; set; }
    }

    public class CheckIPNation_Response
    {
        public HeaderCommon      Header  = new HeaderCommon();
        public CheckIPNation_Res Payload = new CheckIPNation_Res();
    }

    public class ResCMCommon
    {
        public int    ResultCode    { get; set; }
        public string ResultMessage { get; set; }
    }

    public class ReqCMAuthInfo
    {
        public string auth_id          { get; set; }
        public string auth_mac         { get; set; }
        public string auth_pwd         { get; set; }
        public string channel_type     { get; set; }
        public string site_code        { get; set; }
        public string site_custom_code { get; set; }
        public string site_custom_name { get; set; }
    }

    public class ReqCMDeleteAuthInfo
    {
        public string auth_id          { get; set; }
        public string channel_type     { get; set; }
        public string site_code        { get; set; }
        public string site_custom_code { get; set; }
    }

    public class ReqCMOutBoundCall
    {
        public string site_code    { get; set; }
        public string channel_type { get; set; }
        public string caller       { get; set; }
        public string callee       { get; set; }
        public string kind         { get; set; }
        public string message      { get; set; }
    }

    public class ReqCMPhonenoInfo
    {
        public string site_code        { get; set; }
        public string site_custom_code { get; set; }
        public string channel_type     { get; set; }
        public string auth_id          { get; set; }
    }

    public class ResCMPhonenoInfo : ResCMCommon
    {
        public List<CMResultBody> ResultBody { get; set; }
    }

    public class CMResultBody
    {
        public string auth_id      { get; set; }
        public string channel_type { get; set; }
        public int    auth_idx     { get; set; }
        public string create_ts    { get; set; }
        public string phone_no     { get; set; }
        public int    idx          { get; set; }
    }

    public class ReqCMSendGoogleDataMessage
    {
        public string Token     { get; set; }
        public string ProjectID { get; set; }
        public string DataJson  { get; set; }
    }

    public class CMSendGoogleDataMessageDataJson
    {
        public string MsgType { get; set; } //CallPhone, SendSMS
        public string Title   { get; set; }
        public string MsgBody { get; set; }
        public string PhoneNo { get; set; }
        public string SMSText { get; set; }
    }

    public class ResCMSendGoogleDataMessage
    {
        public HeaderCommon Header = new HeaderCommon();
    }
}