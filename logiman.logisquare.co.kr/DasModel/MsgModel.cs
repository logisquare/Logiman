using System.Collections.Generic;

namespace CommonLibrary.DasServices
{

    public class SmsContentModel
    {
        public long   SmsSeqNo 	    { get; set; }
        public string SmsSendCell 	{ get; set; }
        public string SmsTitle 		{ get; set; }
        public string SmsContent 	{ get; set; }
        public string CenterCode 	{ get; set; }
        public string DriverCells   { get; set; }
        public string DriverName    { get; set; }
        public string AdminID       { get; set; }
        public string OrderNos      { get; set; }
        public string SendUrl       { get; set; }
        public string SendNum       { get; set; }
        public int    SuccCnt       { get; set; }
    }

    public class KakaoTalkModel
    {
        public string   OrderNos    { get; set; }
        public long     OrderNo     { get; set; }
        public long     RefSeqNo    { get; set; }
        public long     SeqNo       { get; set; }
        public int      CenterCode  { get; set; }
        public int      SendType    { get; set; }
        public string   SendUrl     { get; set; }
        public string   SendCell    { get; set; }

        public string   RegAdminID      { get; set; }
        public string   RegAdminName    { get; set; }
        public int      TotalCnt        { get; set; }
        public int      ResultCnt       { get; set; }
        public string   ErrMsg          { get; set; }
        public string   PickupYMD       { get; set; }
        public string   PickupHM        { get; set; }
        public string   PickupPlaceAddr { get; set; }
        public string   PickupPlaceAddrDtl { get; set; }
        public string   GetYMD              { get; set; }
        public string   GetHM               { get; set; }
        public string   GetPlaceAddr        { get; set; }
        public string   GetPlaceAddrDtl     { get; set; }

    }
    public class ReqMsgSendLogList
    {
        public int    SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public int    MsgType          { get; set; }
        public string RcvNum           { get; set; }
        public string SendNum          { get; set; }
        public int    RetCodeType      { get; set; }
        public string FromYMD          { get; set; }
        public string ToYMD            { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResMsgSendLogList
    {
        public List<MsgSendLogViewModel> list      { get; set; }
        public int                       RecordCnt { get; set; }
    }

    public class MsgSendLogViewModel
    {
        public int    SeqNo         { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public int    TemplateSeqNo { get; set; }
        public int    MsgType       { get; set; }
        public string MsgTypeM      { get; set; }
        public string SendNum       { get; set; }
        public string RcvNum        { get; set; }
        public string Title         { get; set; }
        public string TitleS        { get; set; }
        public string Contents      { get; set; }
        public string ContentsS     { get; set; }
        public string ReceiptNum    { get; set; }
        public int    RetCode       { get; set; }
        public string RetCodeM      { get; set; }
        public string PGRetCode     { get; set; }
        public string PGRetMsg      { get; set; }
        public string YMD           { get; set; }
        public string RegDate       { get; set; }
    }
    
    public class ReqSmsContentList
    {
        public long    SmsSeqNo     { get; set; }
        public string SmsSendCell  { get; set; }
        public string SmsTitle     { get; set; }
        public string SmsContent   { get; set; }
        public string AdminID      { get; set; }
        public string DelFlag      { get; set; }
        public long   OrderNo      { get; set; }
    }

    public class ResSmsContentList
    {
        public List<SmsContentViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class SmsContentViewModel
    {
        public long SmsSeqNo        { get; set; }
        public string SmsSendCell   { get; set; }
        public string SmsTitle      { get; set; }
        public string SmsContent    { get; set; }
        public string AdminID       { get; set; }
        public string RegDate       { get; set; }
        public string DelFlag       { get; set; }
        public string UpdDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string OrderNo { get; set; }
        public string PickupYMD { get; set; }
        public string ClientName { get; set; }
        public string CenterName { get; set; }
        public string CorpNo { get; set; }
        public string TelNo { get; set; }
        public string Addr { get; set; }
    }
}