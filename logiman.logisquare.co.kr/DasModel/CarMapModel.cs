using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class CarMapGridModel
    {
        public string OrderNo         { get; set; }
        public string CarSeqNo        { get; set; }
        public string CarNo           { get; set; }
        public string DriverSeqNo     { get; set; }
        public string DriverName      { get; set; }
        public string DriverCell      { get; set; }
        public string ComName         { get; set; }
        public int    CarDivType      { get; set; }
        public string CarDivTypeM     { get; set; }
        public int    CenterCode      { get; set; }
        public string CenterName      { get; set; }
        public int    DispatchType    { get; set; }
        public string DispatchTypeM   { get; set; }
        public string OrderItemCode   { get; set; }
        public string OrderItemCodeM  { get; set; }
        public string PickupYMD       { get; set; }
        public string GetYMD          { get; set; }
        public string ConsignorName   { get; set; }
        public string PickupPlace     { get; set; }
        public string PickupPlaceAddr { get; set; }
        public string GetPlace        { get; set; }
        public string GetPlaceAddr    { get; set; }
        public string PickupDT        { get; set; }
        public string ArrivalDT       { get; set; }
        public string GetDT           { get; set; }
    }

    public class GpsGridModel
    {
        public string SeqNo       { get; set; }
        public string AuthTel     { get; set; }
        public string GpsLocation { get; set; }
        public string GLAT        { get; set; }
        public string GLNG        { get; set; }
        public string YMD         { get; set; }
        public string RegDate     { get; set; }
        public string StartFlag   { get; set; }
        public string DriverName  { get; set; }
        public string DriverCell  { get; set; }
        public string CarNo       { get; set; }
    }

    public class GpsInfo
    {
        public string Exists      { get; set; } = string.Empty;
        public string SeqNo       { get; set; } = string.Empty;
        public string ComCorpNo   { get; set; } = string.Empty;
        public string AuthTel     { get; set; } = string.Empty;
        public string DeviceModel { get; set; } = string.Empty;
        public string OSVersion   { get; set; } = string.Empty;
        public string APIVersion  { get; set; } = string.Empty;
        public string Lat         { get; set; } = string.Empty;
        public string Lng         { get; set; } = string.Empty;
        public string RegYMD      { get; set; } = string.Empty;
        public string RegDate     { get; set; } = string.Empty;
    }

    public class ReqCarMapList
    {
        public long   OrderNo        { get; set; }
        public int    CenterCode     { get; set; }
        public int    DateType       { get; set; }
        public string DateFrom       { get; set; }
        public string DateTo         { get; set; }
        public string CarNo          { get; set; }
        public string DriverName     { get; set; }
        public string DriverCell     { get; set; }
        public int    CarDivType     { get; set; }
        public string AuthTel        { get; set; }
        public string YMD            { get; set; }
        public string RegDate        { get; set; }
        public string TotalCarsFlag  { get; set; }
        public int    MaxLinearMeter { get; set; }
        public int    MaxMinutes     { get; set; }
        public int    PageSize       { get; set; }
        public int    PageNo         { get; set; }
    }

    public class ResCarMapList
    {
        public List<CarMapGridModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class ResGpsList
    {
        public List<GpsGridModel> list             { get; set; }
        public int                RecordCnt        { get; set; }
        public int                TotalDistance    { get; set; }
        public string             TotalElapsedTime { get; set; }
    }
}