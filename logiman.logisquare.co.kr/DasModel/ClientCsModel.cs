using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ClientCsViewModel
    {
        public int    CsSeqNo           { get; set; }
        public string CsSeqNos1         { get; set; }
        public string CsSeqNos2         { get; set; }
        public string CsSeqNos3         { get; set; }
        public string CsSeqNos4         { get; set; }
        public string CsSeqNos5         { get; set; }
        public int    ClientCode        { get; set; }
        public int    CenterCode        { get; set; }
        public string OrderItemCode     { get; set; }
        public string OrderInoutCode    { get; set; }
        public string OrderLocationCode { get; set; }
        public int    CsAdminType       { get; set; }
        public string CsAdminID         { get; set; }
        public string CsAdminName       { get; set; }
        public string AdminID           { get; set; }
        public string DelFlag           { get; set; }
    }

    public class ReqClientCsList
    {
        public int    CsSeqNo           { get; set; }
        public int    ClientCode        { get; set; }
        public int    CenterCode        { get; set; }
        public string ClientName        { get; set; }
        public string OrderItemCode     { get; set; }
        public string OrderInoutCode    { get; set; }
        public string OrderLocationCode { get; set; }
        public int    CsAdminType       { get; set; }
        public string CsAdminID         { get; set; }
        public string CsAdminName       { get; set; }
        public string AdminID           { get; set; }
        public string DelFlag           { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }

    }

    public class ResClientCsList
    {
        public List<ClientCsListViewModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ClientCsListViewModel
    {   
        public int    CsSeqNo            { get; set; }
        public long   ClientCode         { get; set; }
        public string ClientName         { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public string OrderItemCode      { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderInoutCode     { get; set; }
        public string OrderInoutCodeM    { get; set; }
        public string OrderLocationCode  { get; set; }
        public string OrderLocationCodeM { get; set; }
        public int    CsAdminType        { get; set; }
        public string CsAdminTypeM       { get; set; }
        public string CsAdminID          { get; set; }
        public string CsAdminName        { get; set; }
        public string RegAdminID         { get; set; }
        public string RegDate            { get; set; }
        public string UpdAdminID         { get; set; }
        public string UpdDate            { get; set; }	
        public string DelFlag            { get; set; }
        public string DelFlagM           { get; set; }
        public string DelAdminID         { get; set; }
        public string DelDate            { get; set; }
    }


    public class ReqClientCsSearchList
    {
        public long   ClientCode        { get; set; }
        public int    CenterCode        { get; set; }
        public string ClientName        { get; set; }
        public string OrderItemCode     { get; set; }
        public string OrderInoutCode    { get; set; }
        public string OrderLocationCode { get; set; }
        public int    CsAdminType       { get; set; }
        public string CsAdminID         { get; set; }
        public string CsAdminName       { get; set; }
        public string DelFlag           { get; set; }
        public string AccessCenterCode  { get; set; }
        public int    PageSize          { get; set; }
        public int    PageNo            { get; set; }

    }

    public class ClientCsSearchListModel
    {
        public string CsAdminTypeM { get; set; }
        public string CsAdminID    { get; set; }
        public string CsAdminName  { get; set; }
    }

    public class ResClientCsSearchList
    {
        public List<ClientCsSearchListModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }
}