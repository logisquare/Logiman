using System.Collections.Generic;

namespace CommonLibrary.DasServices
{


    public class ReqAdminMenuGroupList
    {
        public string MenuGroupNo { get; set; }
        public string MenuGroupKind { get; set; }
        public string MenuGroupName { get; set; }
        public string MenuGroupSort { get; set; }
        public string DisplayImage { get; set; }
        public string DisplayFlag { get; set; }
        public string UseFlag { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }
    }

    public class ResAdminMenuGroupList
    {
        public List<AdminMenuGroupViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class AdminMenuGroupViewModel
    {
        public int MenuGroupNo { get; set; }
        public int MenuGroupKind { get; set; }
        public string MenuGroupName { get; set; }
        public int MenuGroupSort { get; set; }
        public string DisplayImage { get; set; }
        public string DisplayFlag { get; set; }
        public string UseFlag { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }

        public string MenuGroupKindM{ get; set; }
    }


    public class ReqAdminMenuList
    {
        public int MenuNo { get; set; }
        public string MenuGroupNo { get; set; }
        public string MenuName { get; set; }
        public string MenuLink { get; set; }
        public int MenuSort { get; set; }
        public string MenuDesc { get; set; }
        public int UseStateCode { get; set; }
        public string MenuGroupName { get; set; }
    }

    public class ResAdminMenuList
    {
        public List<AdminMenuViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class AdminMenuViewModel
    {
        public string MenuNo { get; set; }
        public int MenuGroupNo { get; set; }
        public string MenuName { get; set; }
        public string MenuLink { get; set; }
        public int MenuSort { get; set; }
        public string MenuDesc { get; set; }
        public int UseStateCode { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }
        public string MenuGroupName { get; set; }
    }

    public class ReqAdminMenuRoleList
    {
        public int MenuRoleNo { get; set; }
        public string MenuRoleName { get; set; }
        public string UseFlag { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }

    }
    public class ResAdminMenuRoleList
    {
        public List<AdminMenuRoleViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }
    public class AdminMenuRoleViewModel
    {
        public int MenuRoleNo { get; set; }
        public string MenuRoleName { get; set; }
        public string UseFlag { get; set; }
        public string RegDate { get; set; }
        public string UpdDate { get; set; }

    }

    public class ReqAdminMenuRoleDtlList
    {
        public string MenuRoleNo { get; set; }
        public int MenuNo { get; set; }
        public int AuthCode { get; set; }
        public string RegDate { get; set; }
    }
    public class ResAdminMenuRoleDtlList
    {

        public List<AdminMenuRoleDtlViewModel> list { get; set; }
        public int RecordCnt { get; set; }
    }
    public class AdminMenuRoleDtlViewModel
    {
        public int    MenuGroupNo    { get; set; }
        public int    MenuRoleNo     { get; set; }
        public int    MenuNo         { get; set; }
        public string MenuGroupKindM { get; set; }
        public string MenuName       { get; set; }
        public int    Depth          { get; set; }
        public int    SortNo         { get; set; }
        public string pSortNo        { get; set; }
        public int    UseStateCode   { get; set; }
        public int    AuthCode       { get; set; }
        public string RegDate        { get; set; }

    }
}
