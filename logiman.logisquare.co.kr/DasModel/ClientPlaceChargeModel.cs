using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ClientPlaceChargeViewModel 
    {
        public int    ChargeSeqNo      { get; set; }
        public long   PlaceSeqNo       { get; set; }
        public int    ClientCode       { get; set; }
        public string ClientCorpNo     { get; set; }
        public int    CenterCode       { get; set; }
        public string PlaceName        { get; set; }
        public string PlacePost        { get; set; }
        public string PlaceAddr        { get; set; }
        public string PlaceAddrDtl     { get; set; }
        public string Sido             { get; set; }
        public string Gugun            { get; set; }
        public string Dong             { get; set; }
        public string FullAddr         { get; set; }
        public string ChargeName       { get; set; }
        public string ChargePosition   { get; set; }
        public string ChargeTelExtNo   { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeFaxNo      { get; set; }
        public string ChargeEmail      { get; set; }
        public string ChargeDepartment { get; set; }
        public string ChargeCell       { get; set; }
        public string ChargeNote       { get; set; }
        public string LocalCode        { get; set; }
        public string LocalName        { get; set; }
        public string PlaceRemark1     { get; set; }
        public string PlaceRemark2     { get; set; }
        public string PlaceRemark3     { get; set; }
        public string PlaceRemark4     { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
        public string SeqNos1          { get; set; }
        public string SeqNos2          { get; set; }
        public string SeqNos3          { get; set; }
        public string SeqNos4          { get; set; }
        public string SeqNos5          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    GradeCode        { get; set; }
        public string UseFlag          { get; set; }
        public string PlaceNote        { get; set; }
    }

    public class ReqClientPlaceChargeList
    {
        public long   PlaceSeqNo       { get; set; }
        public int    SeqNo            { get; set; }
        public int    SeqNoType        { get; set; }
        public int    CenterCode       { get; set; }
        public long   ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public string SearchType       { get; set; }
        public string PlaceName        { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeCell       { get; set; }
        public string UseFlag          { get; set; }
        public string PlaceAddr        { get; set; }
        public string FullAddr         { get; set; }
        public string ChargeUseFlag    { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
        
    }

    public class ResClientPlaceChargeList
    {
        public List<ClientPlaceChargeListViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class ClientPlaceChargeListViewModel
    {   
        //상하차지 담당자
        public int SeqNo                    { get; set; }
        public int PlaceSeqNo               { get; set; }
        public string ClientName            { get; set; }
        public string ChargeName            { get; set; }
        public string ChargeTelNo           { get; set; }
        public string ChargeTelExtNo        { get; set; }
        public string ChargeCell            { get; set; }
        public string ChargeFaxNo           { get; set; }
        public string ChargeEmail           { get; set; }
        public string ChargePosition        { get; set; }
        public string ChargeDepartment      { get; set; }
        public string ChargeNote            { get; set; }
        public string UseFlag               { get; set; }
        public string UseFlagM              { get; set; }
        public string RegAdminID            { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdDate               { get; set; }
        //상하차지
        public int CenterCode               { get; set; }
        public int ClientCode               { get; set; }
        public string PlaceName             { get; set; }
        public string PlacePost             { get; set; }
        public string PlaceAddr             { get; set; }
        public string PlaceAddrDtl          { get; set; }
        public string Sido                  { get; set; }
        public string Gugun                 { get; set; }
        public string Dong                  { get; set; }
        public string FullAddr              { get; set; }
        public string LocalCode             { get; set; }
        public string LocalName             { get; set; }
        public string PlaceRemark1          { get; set; }
        public string PlaceRemark2          { get; set; }
        public string PlaceRemark3          { get; set; }
        public string PlaceRemark4          { get; set; }
        public string PlaceNote             { get; set; }
        public string PlaceUseFlag          { get; set; }
        public string PlaceRegAdminID       { get; set; }
        public string PlaceRegDate          { get; set; }
        public string PlaceUpdAdminID       { get; set; }
        public string PlaceUpdDate          { get; set; }
        //검색
        public string PlaceInfo             { get; set; }
        public string ChargeInfo            { get; set; }
    }

    public class ClientPlaceSearchModel
    {
        public int    PlaceSeqNo       { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public int    ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public string PlaceName        { get; set; }
        public string PlacePost        { get; set; }
        public string PlaceAddr        { get; set; }
        public string PlaceAddrDtl     { get; set; }
        public string Sido             { get; set; }
        public string Gugun            { get; set; }
        public string Dong             { get; set; }
        public string FullAddr         { get; set; }
        public string LocalCode        { get; set; }
        public string LocalName        { get; set; }
        public string PlaceRemark1     { get; set; }
        public string PlaceRemark2     { get; set; }
        public string PlaceRemark3     { get; set; }
        public string PlaceRemark4     { get; set; }
        public string UseFlag          { get; set; }
        public string PlaceInfo        { get; set; }
        public string RegAdminID       { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdDate          { get; set; }
        public int    ChargeSeqNo      { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeTelExtNo   { get; set; }
        public string ChargeCell       { get; set; }
        public string ChargePosition   { get; set; }
        public string ChargeDepartment { get; set; }
        public string ChargeNote       { get; set; }
        public string ChargeUseFlag    { get; set; }
        public string ChargeInfo       { get; set; }
    }

    public class ReqClientPlaceSearchList
    {
        public int    CenterCode       { get; set; }
        public string PlaceName        { get; set; }
        public string UseFlag          { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeUseFlag    { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }

    }

    public class ResClientPlaceSearchList
    {
        public List<ClientPlaceSearchModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }


    public class ClientPlaceChargeSearchModel
    {
        public int    PlaceSeqNo       { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public int    ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public string PlaceName        { get; set; }
        public string PlacePost        { get; set; }
        public string PlaceAddr        { get; set; }
        public string PlaceAddrDtl     { get; set; }
        public string Sido             { get; set; }
        public string Gugun            { get; set; }
        public string Dong             { get; set; }
        public string FullAddr         { get; set; }
        public string LocalCode        { get; set; }
        public string LocalName        { get; set; }
        public string PlaceRemark1     { get; set; }
        public string PlaceRemark2     { get; set; }
        public string PlaceRemark3     { get; set; }
        public string PlaceRemark4     { get; set; }
        public string UseFlag          { get; set; }
        public string PlaceInfo        { get; set; }
        public string RegAdminID       { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdDate          { get; set; }
        public int    ChargeSeqNo      { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeTelNo      { get; set; }
        public string ChargeTelExtNo   { get; set; }
        public string ChargeCell       { get; set; }
        public string ChargePosition   { get; set; }
        public string ChargeDepartment { get; set; }
        public string ChargeNote       { get; set; }
        public string ChargeUseFlag    { get; set; }
        public string ChargeInfo       { get; set; }
    }

    public class ReqClientPlaceChargeSearchList
    {
        public int    CenterCode       { get; set; }
        public long   PlaceSeqNo       { get; set; }
        public string PlaceName        { get; set; }
        public string UseFlag          { get; set; }
        public string ChargeName       { get; set; }
        public string ChargeUseFlag    { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }

    }

    public class ResClientPlaceChargeSearchList
    {
        public List<ClientPlaceChargeSearchModel> list { get; set; }
        public int RecordCnt { get; set; }
    }


    public class ReqClientPlaceNote
    {
        public int    CenterCode   { get; set; }
        public string PlaceName    { get; set; }
        public string PlaceAddr    { get; set; }
        public string PlaceAddrDtl { get; set; }
        public string AdminID      { get; set; }
    }

    public class ResClientPlaceNote
    {
        public string PlaceSeqNo   { get; set; }
        public string PlaceRemark1 { get; set; }
        public string PlaceRemark2 { get; set; }
        public string PlaceRemark3 { get; set; }
        public string PlaceRemark4 { get; set; }
    }

    public class ReqClientPlaceNoteUpd
    {
        public int    CenterCode   { get; set; }
        public int    OrderType    { get; set; }
        public long   PlaceSeqNo   { get; set; }
        public string PlaceRemark1 { get; set; }
        public string PlaceRemark2 { get; set; }
        public string PlaceRemark3 { get; set; }
        public string PlaceRemark4 { get; set; }
        public string AdminID      { get; set; }
    }
}