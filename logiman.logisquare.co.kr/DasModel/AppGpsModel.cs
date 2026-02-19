using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class AppGpsGridModel
    {
        public string SeqNo          { get; set; }
        public string MobileNo       { get; set; }
        public string GpsLocationLat { get; set; }
        public string GpsLocationLng { get; set; }
        public string StartFlag      { get; set; }
        public string YMD            { get; set; }
        public string RegDate        { get; set; }
    }

    public class ReqAppGpsList
    {
        public string MobileNo       { get; set; }
        public string DateFrom       { get; set; }
        public string DateTo         { get; set; }
        public int    MaxLinearMeter { get; set; }
        public int    MaxMinutes     { get; set; }
    }

    public class ResAppGpsList
    {
        public List<AppGpsGridModel> list             { get; set; }
        public int                   RecordCnt        { get; set; }
        public int                   TotalDistance    { get; set; }
        public string                TotalElapsedTime { get; set; }
    }
}