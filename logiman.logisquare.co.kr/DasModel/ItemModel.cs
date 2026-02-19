using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ItemModel
    {
        public int    SeqNo         { get; set; }
        public string ItemGroupCode { get; set; }
        public string ItemCode      { get; set; }
        public string ItemFullCode  { get; set; }
        public string ItemName      { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string GroupCode     { get; set; }
        public string GroupName     { get; set; }
        public string CenterFlag    { get; set; }
        public string AdminFlag     { get; set; }
        public string CenterCodes   { get; set; }
    }

    public class ItemGroupModel
    {
        public int    SeqNo      { get; set; }
        public string GroupCode  { get; set; }
        public string GroupName  { get; set; }
        public string CenterFlag { get; set; }
        public string AdminFlag  { get; set; }
        public int    ItemCnt    { get; set; }
    }

    public class ItemCenterModel
    {
        public int    SeqNo        { get; set; }
        public int    CenterCode   { get; set; }
        public string CenterName   { get; set; }
        public string GroupCode    { get; set; }
        public string GroupName    { get; set; }
        public string ItemCode     { get; set; }
        public string ItemFullCode { get; set; }
        public string ItemName     { get; set; }
        public string UseFlag      { get; set; }
        public string OrgUseFlag   { get; set; }
        public string RegAdminID   { get; set; }
        public string RegDate      { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdDate      { get; set; }
    }

    public class ItemAdminModel
    {
        public int    SeqNo           { get; set; }
        public string ItemGroupCode   { get; set; }
        public string ItemCode        { get; set; }
        public string ItemFullCode    { get; set; }
        public string ItemName        { get; set; }
        public string GroupCode       { get; set; }
        public string GroupName       { get; set; }
        public string BookmarkFlag    { get; set; }
        public string OrgBookmarkFlag { get; set; }
        public int    AdminSort       { get; set; }
        public string AdminID         { get; set; }
        public string RegAdminID      { get; set; }
        public string RegDate         { get; set; }
    }

    public class ReqItemGroupList
    {
        public int    SeqNo      { get; set; }
        public string GroupCode  { get; set; }
        public string GroupName  { get; set; }
        public string CenterFlag { get; set; }
        public string AdminFlag  { get; set; }

        public int    PageSize  { get; set; }
        public int    PageNo    { get; set; }
    }

    public class ResItemGroupList
    {
        public List<ItemGroupModel> list      { get; set; }
        public int                  RecordCnt { get; set; }
    }


    public class ReqItemList
    {
        public int    SeqNo        { get; set; }
        public string GroupCode    { get; set; }
        public string GroupName    { get; set; }
        public string ItemCode     { get; set; }
        public string ItemFullCode { get; set; }
        public string ItemName     { get; set; }
        public int    PageSize     { get; set; }
        public int    PageNo       { get; set; }
    }

    public class ResItemList
    {
        public List<ItemModel> list      { get; set; }
        public int             RecordCnt { get; set; }
    }

    public class ReqItemCenterList
    {
        public string CenterCodes  { get; set; }
        public string GroupCode    { get; set; }
        public string GroupName    { get; set; }
        public string ItemCode     { get; set; }
        public string ItemFullCode { get; set; }
        public string ItemName     { get; set; }
        public int    PageSize     { get; set; }
        public int    PageNo       { get; set; }
    }

    public class ResItemCenterList
    {
        public List<ItemCenterModel> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }

    public class ReqItemAdminList
    {
        public string GroupCode    { get; set; }
        public string ItemFullCode { get; set; }
        public string AdminID     { get; set; }
        public int    PageSize     { get; set; }
        public int    PageNo       { get; set; }
    }

    public class ResItemAdminList
    {
        public List<ItemAdminModel> list      { get; set; }
        public int                  RecordCnt { get; set; }
    }
}