namespace CommonLibrary.DasServices
{
        public class ReqAppVersionChk
    {
        public int DeviceKind           { get; set; }
        public int AppKind              { get; set; }
    }

    public class ResAppVersionChk
    {
        public int VerSeqNo             { get; set; }
        public string AppVersion        { get; set; }
        public string AppVersionDesc    { get; set; }
        public string DownloadForce     { get; set; }
        public string ServiceStopFlag   { get; set; }
        public string NoticeTitle       { get; set; }
        public string NoticeMessage     { get; set; }
        public string RegDate           { get; set; }
    }
}