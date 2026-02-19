using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;
using System;
using System.Collections.Generic;
using System.Data;

namespace CommonLibrary.DasServices
{
    public class AdminMenuDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 관리자메뉴 리스트
        /// </summary>
        public ServiceResult<ResAdminMenuList> GetAdminMenuList(ReqAdminMenuList objReqAdminMenuList)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuList REQ] {JsonConvert.SerializeObject(objReqAdminMenuList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResAdminMenuList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo", DBType.adInteger, objReqAdminMenuList.MenuGroupNo,               0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuNo",      DBType.adInteger, objReqAdminMenuList.MenuNo, 0, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuList
                {
                    list = new List<AdminMenuViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminMenuList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        public ServiceResult<bool> DelAdminMenu(string strMenuNo)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenu REQ] {strMenuNo}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;
            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuNo",   DBType.adInteger, strMenuNo,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",   DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",   DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_TX_DEL");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to delete adminmenu's menu" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenu RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;

        }
        /// <summary>
        /// 관리자메뉴 그룹 리스트
        /// </summary>
        public ServiceResult<ResAdminMenuGroupList> GetAdminMenuGroupInfo(ReqAdminMenuGroupList objReqAdminMenuGroupList)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetMenuGroupInfo REQ] {JsonConvert.SerializeObject(objReqAdminMenuGroupList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResAdminMenuGroupList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuGroupList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo",   DBType.adInteger,  objReqAdminMenuGroupList.MenuGroupNo, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuGroupName", DBType.adVarWChar, DBNull.Value,                         50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",       DBType.adChar,     DBNull.Value,                         1,  ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_GROUP_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuGroupList
                {
                    list = new List<AdminMenuGroupViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuGroupViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetMenuGroupInfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuGroupList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelAdminMenuGroup(string strMenuGroupNo)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenuGroup REQ] {JsonConvert.SerializeObject(strMenuGroupNo)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo", DBType.adInteger, strMenuGroupNo, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger, DBNull.Value,   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger, DBNull.Value,   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_GROUP_TX_DEL");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to delete adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenuGroup RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;

        }

        public ServiceResult<bool> UpAdminMenuGroup(ReqAdminMenuGroupList objReqUpAdminMenuGroup)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpAdminMenuGroup REQ] {JsonConvert.SerializeObject(objReqUpAdminMenuGroup)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo",   DBType.adInteger,  objReqUpAdminMenuGroup.MenuGroupNo,   0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuGroupKind", DBType.adTinyInt,  objReqUpAdminMenuGroup.MenuGroupKind, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuGroupName", DBType.adVarWChar, objReqUpAdminMenuGroup.MenuGroupName, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuGroupSort", DBType.adSmallInt, objReqUpAdminMenuGroup.MenuGroupSort, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDisplayImage",  DBType.adVarWChar, DBNull.Value,                         50,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDisplayFlag",   DBType.adChar,     objReqUpAdminMenuGroup.DisplayFlag,   1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",       DBType.adChar,     objReqUpAdminMenuGroup.UseFlag,       1,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,  DBNull.Value,                         256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,  DBNull.Value,                         256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_GROUP_TX_UPD");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to update adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenuGroup RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;

        }


        public ServiceResult<bool> InsAdminMenu(AdminMenuViewModel objInsAdminMenu)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[InsAdminMenu REQ] {JsonConvert.SerializeObject(objInsAdminMenu)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo",  DBType.adInteger,  objInsAdminMenu.MenuGroupNo,  0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuName",     DBType.adVarWChar, objInsAdminMenu.MenuName,     50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuLink",     DBType.adVarChar,  objInsAdminMenu.MenuLink,     100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuDesc",     DBType.adVarWChar, objInsAdminMenu.MenuDesc,     1000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intUseStateCode", DBType.adTinyInt,  objInsAdminMenu.UseStateCode, 0,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar, DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger, DBNull.Value,                  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar, DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger, DBNull.Value,                  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_TX_INS");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[InsAdminMenu RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }



        /// <summary>
        /// 관리자메뉴 수정
        /// </summary>
        public ServiceResult<bool> UpdAdminMenu(AdminMenuViewModel objUpdAdminMenu)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpdAdminMenu REQ] {JsonConvert.SerializeObject(objUpdAdminMenu)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuNo",       DBType.adInteger,  objUpdAdminMenu.MenuNo,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuName",     DBType.adVarWChar, objUpdAdminMenu.MenuName,     50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuLink",     DBType.adVarChar,  objUpdAdminMenu.MenuLink,     100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuSort",     DBType.adSmallInt, objUpdAdminMenu.MenuSort,     0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuDesc",     DBType.adVarWChar, objUpdAdminMenu.MenuDesc,     1000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intUseStateCode", DBType.adTinyInt,  objUpdAdminMenu.UseStateCode, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,  DBNull.Value,                 256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,  DBNull.Value,                 0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,  DBNull.Value,                 256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,  DBNull.Value,                 0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_TX_UPD");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to update adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpdAdminMenu RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        //메뉴역할관리리스트
        public ServiceResult<ResAdminMenuRoleList> GetAdminMenuRoleList(ReqAdminMenuRoleList objReqAdminMenuRoleList)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuRoleList REQ] {JsonConvert.SerializeObject(objReqAdminMenuRoleList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResAdminMenuRoleList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuRoleList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuRoleNo", DBType.adInteger, objReqAdminMenuRoleList.MenuRoleNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",    DBType.adChar,    DBNull.Value,                       1, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuRoleList
                {
                    list = new List<AdminMenuRoleViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuRoleViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminMenuRoleList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuRoleList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelAdminMenuRole(AdminMenuRoleViewModel objDelAdminMenuRole)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[DelAdminMenuRole REQ] {JsonConvert.SerializeObject(objDelAdminMenuRole)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuRoleNo", DBType.adInteger, objDelAdminMenuRole.MenuRoleNo, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger, DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger, DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_TX_DEL");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to update adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpdAdminMenu RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResAdminMenuRoleDtlList> GetAdminMenuRoleDtlList(ReqAdminMenuRoleDtlList objReqAdminMenuRoleDtlList)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuRoleDtlList REQ] {JsonConvert.SerializeObject(objReqAdminMenuRoleDtlList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResAdminMenuRoleDtlList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuRoleDtlList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuRoleNo", DBType.adInteger, objReqAdminMenuRoleDtlList.MenuRoleNo, 0, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_DTL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuRoleDtlList
                {
                    list      = new List<AdminMenuRoleDtlViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuRoleDtlViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminMenuRoleDtlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[GetAdminMenuRoleDtlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsRole(string strMenuRoleName,string strMenuList,string strAuthCode,string strRwAuthCode,string strRoAuthCode,string strUseFlag)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[InsRole REQ] {strMenuRoleName}/{strMenuList}/{strAuthCode}/{strRwAuthCode}/{strRoAuthCode}/{strUseFlag}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMenuRoleName", DBType.adVarWChar, strMenuRoleName, 50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuList",     DBType.adVarChar,  strMenuList,     2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllAuthCode",  DBType.adVarChar,  strAuthCode,     2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRwAuthCode",   DBType.adVarChar,  strRwAuthCode,   2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRoAuthCode",   DBType.adVarChar,  strRoAuthCode,   2000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",      DBType.adChar,     strUseFlag,      1,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,  DBNull.Value,    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,  DBNull.Value,    0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,  DBNull.Value,    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,  DBNull.Value,    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_TX_INS");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert adminmenu's role" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[InsRole RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdRole(string strMenuRoleNo, string strMenuRoleName,string strAddMenuList, string strRmMenuList, string strAllAuthCode, string strRoAuthCode, string strRwAuthCode, string strUseFlag)
        {
            SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpdRole REQ] {strMenuRoleNo}/{strMenuRoleName}/{strAddMenuList}/{strRmMenuList}/{strAllAuthCode}/{strRoAuthCode}/{strRwAuthCode}/{strUseFlag}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuRoleNo",   DBType.adInteger,  strMenuRoleNo,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuRoleName", DBType.adVarWChar, strMenuRoleName, 50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddMenuList",  DBType.adVarChar,  strAddMenuList,  2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRmMenuList",   DBType.adVarChar,  strRmMenuList,   2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllAuthCode",  DBType.adVarChar,  strAllAuthCode,  2000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRwAuthCode",   DBType.adVarChar,  strRwAuthCode,   2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRoAuthCode",   DBType.adVarChar,  strRoAuthCode,   2000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",      DBType.adChar,     strUseFlag,      1,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,  DBNull.Value,    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,  DBNull.Value,    0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,  DBNull.Value,    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,  DBNull.Value,    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_TX_UPD");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                            , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to update adminmenu's role" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminMenuDasServices", "I", $"[UpdRole RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

    }
}