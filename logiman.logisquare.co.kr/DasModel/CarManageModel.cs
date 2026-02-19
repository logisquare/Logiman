using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class DispatchListGridModel
    {
        public int    RowNo               { get; set; }
        public string ComCode             { get; set; }
        public string ComName             { get; set; }
        public string ComCorpNo           { get; set; }
        public string CarSeqNo            { get; set; }
        public string CarNo               { get; set; }
        public string CarTypeCode         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string CarTonCode          { get; set; }
        public string CarTonCodeM         { get; set; }
        public string DriverSeqNo         { get; set; }
        public string DriverName          { get; set; }
        public string DriverCell          { get; set; }
        public string PickupPlaceFullAddr { get; set; }
        public string GetPlaceFullAddr    { get; set; }
        public int    DispatchCnt         { get; set; }
        public string ManageFlag          { get; set; }
    }

    public class ReqDispatchList
    {
        public int    CenterCode       { get; set; }
        public int    DateType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string ComName          { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarNo            { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string DispatchAdminID  { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResDispatchList
    {
        public List<DispatchListGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class CarManageDispatchGridModel
    {
        public int    CarDispatchType     { get; set; }
        public string CarDispatchTypeM    { get; set; }
        public int    CenterCode          { get; set; }
        public string CenterName          { get; set; }
        public string OrderNo             { get; set; }
        public string PickupPlaceFullAddr { get; set; }
        public string GetYMD              { get; set; }
        public string GetHM               { get; set; }
        public string GetPlaceFullAddr    { get; set; }
        public string ComCode             { get; set; }
        public string ComName             { get; set; }
        public string ComCorpNo           { get; set; }
        public string CarSeqNo            { get; set; }
        public string CarNo               { get; set; }
        public string CarTypeCode         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string CarTonCode          { get; set; }
        public string CarTonCodeM         { get; set; }
        public string DriverSeqNo         { get; set; }
        public string DriverName          { get; set; }
        public string DriverCell          { get; set; }
        public string DispatchAdminName   { get; set; }
        public string MobileNo            { get; set; }
        public double AreaDistance        { get; set; }
        public int    DispatchCnt         { get; set; }
    }

    public class ReqCarManageDispatchSearchList
    {
        public int    CenterCode     { get; set; } = 0;
        public long   OrderNo        { get; set; } = 0;
        public string PickupYMD      { get; set; }
        public string PickupFullAddr { get; set; }
        public string AdminID        { get; set; }
        public int    PageSize       { get; set; }
        public int    PageNo         { get; set; }
    }

    public class ResCarManageDispatchSearchList
    {
        public List<CarManageDispatchGridModel> list      { get; set; }
        public int                              RecordCnt { get; set; }
    }


    public class CarManageGridModel
    {
        public string ManageSeqNo      { get; set; }
        public string ComCode          { get; set; }
        public string ComName          { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarSeqNo         { get; set; }
        public string CarNo            { get; set; }
        public string CarTypeCode      { get; set; }
        public string CarTypeCodeM     { get; set; }
        public string CarTonCode       { get; set; }
        public string CarTonCodeM      { get; set; }
        public string DriverSeqNo      { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string PickupFullAddr1  { get; set; }
        public string GetFullAddr1     { get; set; }
        public string PickupFullAddr2  { get; set; }
        public string GetFullAddr2     { get; set; }
        public string PickupFullAddr3  { get; set; }
        public string GetFullAddr3     { get; set; }
        public string DayInfo          { get; set; }
        public string EndYMDFlag       { get; set; }
        public string EndYMD           { get; set; }
        public string ShareFlag        { get; set; }
        public string RegAdminID       { get; set; }
        public string RegAdminName     { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
        public string UpdDate          { get; set; }
        public int    DispatchCnt      { get; set; } = 0;
        public int    CarDispatchType  { get; set; } = 0;
        public string CarDispatchTypeM { get; set; }
    }

    public class ReqCarManageList
    {
        public long   ManageSeqNo      { get; set; }
        public int    CenterCode       { get; set; }
        public string ComName          { get; set; }
        public string ComCorpNo        { get; set; }
        public string CarNo            { get; set; }
        public string DriverName       { get; set; }
        public string DriverCell       { get; set; }
        public string ShareFlag        { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResCarManageList
    {
        public List<CarManageGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class ReqCarManageSearchList
    {
        public string PickupYMD      { get; set; }
        public string PickupFullAddr { get; set; }
        public string GetFullAddr    { get; set; }
        public string AdminID        { get; set; }
        public int    PageSize       { get; set; }
        public int    PageNo         { get; set; }
    }

    public class ResCarManageSearchList
    {
        public List<CarManageGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class ReqCarManageDel
    {
        public string ManageSeqNos { get; set; }
        public string DelAdminID   { get; set; }
    }

    public class ReqCarManageDispatchIns
    {
        public int    CarDispatchType { get; set; }
        public long   RefSeqNo        { get; set; }
        public string ComName         { get; set; }
        public string ComCorpNo       { get; set; }
        public string CarNo           { get; set; }
        public string CarTypeCode     { get; set; }
        public string CarTonCode      { get; set; }
        public string DriverName      { get; set; }
        public string DriverCell      { get; set; }
        public int    OrgCenterCode   { get; set; }
        public long   OrgOrderNo      { get; set; }
        public int    CenterCode      { get; set; }
        public long   OrderNo         { get; set; }
        public double AreaDistance    { get; set; }
        public string RegAdminID      { get; set; }
    }
}