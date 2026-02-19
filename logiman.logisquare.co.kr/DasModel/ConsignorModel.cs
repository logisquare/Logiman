using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ConsignorModel
    {
        public int    ConsignorCode { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public string ConsignorName { get; set; }
        public string ConsignorNote { get; set; }
        public int    ClientCnt     { get; set; }
        public string UseFlag       { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdDate       { get; set; }
    }

    public class ReqConsignorList
    {
        public int    ConsignorCode    { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public string ConsignorName    { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResConsignorList
    {
        public List<ConsignorModel> list      { get; set; }
        public int                  RecordCnt { get; set; }
    }

    public class ConsignorSearchModel
    {
        public int    ConsignorCode { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public string ConsignorName { get; set; }
        public string ConsignorNote { get; set; }
        public string ConsignorInfo { get; set; }
        public string UseFlag       { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdDate       { get; set; }
    }

    public class ReqConsignorSearchList
    {
        public int    CenterCode       { get; set; }
        public int    ClientCode       { get; set; }
        public string ConsignorName    { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResConsignorSearchList
    {
        public List<ConsignorSearchModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }

    public class ConsignorMapSearchModel
    {
        public string ConsignorCode            { get; set; }
        public int    CenterCode               { get; set; }
        public string CenterName               { get; set; }
        public string ConsignorName            { get; set; }
        public string ConsignorNote            { get; set; }
        public string ConsignorInfo            { get; set; }
        public string UseFlag                  { get; set; }
        public string RegAdminID               { get; set; }
        public string RegDate                  { get; set; }
        public string UpdAdminID               { get; set; }
        public string UpdDate                  { get; set; }
        public string OrderClientCode          { get; set; }
        public string OrderClientName          { get; set; }
        public string OrderClientInfo          { get; set; }
        public string OrderClientMisuFlag      { get; set; }
        public double OrderClientTotalMisuAmt  { get; set; }
        public double OrderClientMisuAmt       { get; set; }
        public int    OrderClientNoMatchingCnt { get; set; }
        public string PayClientCode            { get; set; }
        public string PayClientName            { get; set; }
        public string PayClientInfo            { get; set; }
        public string PayClientMisuFlag        { get; set; }
        public double PayClientTotalMisuAmt    { get; set; }
        public double PayClientMisuAmt         { get; set; }
        public int    PayClientNoMatchingCnt   { get; set; }
        public string PickupPlaceSeqNo         { get; set; }
        public string PickupPlaceName          { get; set; }
        public string PickupPlacePost          { get; set; }
        public string PickupPlaceAddr          { get; set; }
        public string PickupPlaceAddrDtl       { get; set; }
        public string PickupFullAddr           { get; set; }
        public string PickupPlaceRemark        { get; set; }
        public string PickupPlaceInfo          { get; set; }
        public string GetPlaceSeqNo            { get; set; }
        public string GetPlaceName             { get; set; }
        public string GetPlacePost             { get; set; }
        public string GetPlaceAddr             { get; set; }
        public string GetPlaceAddrDtl          { get; set; }
        public string GetFullAddr              { get; set; }
        public string GetPlaceRemark           { get; set; }
        public string GetPlaceInfo             { get; set; }
    }

    public class ReqConsignorMapSearchList
    {
        public int    CenterCode       { get; set; }
        public string ConsignorName    { get; set; }
        public string UseFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResConsignorMapSearchList
    {
        public List<ConsignorMapSearchModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }

    public class ConsignorGMModel
    {
        public long   GMSeqNo                   { get; set; }
        public int    CenterCode                { get; set; }
        public long   ConsignorCode             { get; set; }
        public string LocationAlias             { get; set; }
        public string Shipper                   { get; set; }
        public string Origin                    { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string DelAdminID                { get; set; }
        public string DelAdminName              { get; set; }
    }

    public class ConsignorGMGridModel
    {
        public string GMSeqNo                   { get; set; }
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string ConsignorCode             { get; set; }
        public string ConsignorName             { get; set; }
        public string LocationAlias             { get; set; }
        public string Shipper                   { get; set; }
        public string Origin                    { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string RegDate                   { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string DelFlag                   { get; set; }
        public string DelAdminID                { get; set; }
        public string DelAdminName              { get; set; }
        public string DelDate                   { get; set; }
    }

    public class ReqConsignorGMList
    {
        public long   GMSeqNo          { get; set; }
        public int    CenterCode       { get; set; }
        public string ConsignorName    { get; set; }
        public string LocationAlias    { get; set; }
        public string Shipper          { get; set; }
        public string Origin           { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResConsignorGMList
    {
        public List<ConsignorGMGridModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }
}