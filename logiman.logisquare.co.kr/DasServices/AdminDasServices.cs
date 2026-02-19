using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;
using System;
using System.Collections.Generic;
using System.Data;

namespace CommonLibrary.DasServices
{
    public class AdminDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        public ServiceResult<AdminSessionInfo> InsAdminLog(ref IDasNetCom objDas, string strAdminID, int intMenuNo, string strMenuLink, int intMenuAuthType, int intPageType, string strCallParam)
        {
            bool bReuseSocket = false;
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminLog REQ] {strAdminID}/{intMenuNo}/{strMenuLink}/{intMenuAuthType}/{strCallParam}", bLogWrite);

            ServiceResult<AdminSessionInfo> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                if (objDas != null)
                {
                    lo_objDas    = objDas;
                    bReuseSocket = true;
                }
                else
                {
                    lo_objDas = new IDasNetCom();
                    lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                }

                lo_objResult = new ServiceResult<AdminSessionInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar,  strAdminID,                 50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuNo",       DBType.adInteger,  intMenuNo,                  0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuLink",     DBType.adVarChar,  strMenuLink,                100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMenuAuthType", DBType.adTinyInt,  intMenuAuthType,            0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageType",     DBType.adTinyInt,  intPageType,                0,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strIPAddr",       DBType.adVarChar,  SiteGlobal.GetRemoteAddr(), 50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallParam",    DBType.adVarWChar, strCallParam,               4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",        DBType.adInteger,  DBNull.Value,               0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,  DBNull.Value,               256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,  DBNull.Value,               0,     ParameterDirection.Output);
                                                                                                                
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,  DBNull.Value,               256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,  DBNull.Value,               0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_LOG_TX_INS", bReuseSocket);

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
                                     , 9101, "System error(InsAdminLog)" + ex.Message);
            }
            finally
            {
                if (bReuseSocket.Equals(false) && lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminLog RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsAdminLoginFail(string strAdminID, string strLoginFailDesc)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminLoginFail REQ] {strAdminID}/{strLoginFailDesc}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,  strAdminID,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLoginFailDesc", DBType.adVarWChar, strLoginFailDesc, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,  DBNull.Value,     256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,  DBNull.Value,     0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,  DBNull.Value,     256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,  DBNull.Value,     0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_LOGIN_FAIL_TX_INS");


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
                                     , 9101, "System error(InsAdminLoginFail) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminLoginFail RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<AdminSessionInfo> GetAdminSession(ref IDasNetCom objDas, string strSessionKey, string strIPAddr)
        {
            bool bReuseSocket = false;
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminSession REQ] {strSessionKey}/{strIPAddr}", bLogWrite);

            ServiceResult<AdminSessionInfo> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                if (objDas != null)
                {
                    lo_objDas    = objDas;
                    bReuseSocket = true;
                }
                else
                {
                    lo_objDas = new IDasNetCom();
                    lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                }

                lo_objResult = new ServiceResult<AdminSessionInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSessionKey",            DBType.adVarChar,  strSessionKey, 50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strIPAddr",                DBType.adVarChar,  strIPAddr,     50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strAdminID",               DBType.adVarChar,  DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strMobileNo",              DBType.adVarChar,  DBNull.Value,  20,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminName",             DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                                                                                                                      
                lo_objDas.AddParam("@po_strPrivateAvailFlag",      DBType.adChar,     DBNull.Value,  1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeptName",              DBType.adVarWChar, DBNull.Value,  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strTelNo",                 DBType.adVarChar,  DBNull.Value,  20,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strEmail",                 DBType.adVarWChar, DBNull.Value,  100,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strWebTemplate",           DBType.adVarChar,  DBNull.Value,  50,   ParameterDirection.Output);
                                                                                                                      
                lo_objDas.AddParam("@po_intGradeCode",             DBType.adTinyInt,  DBNull.Value,  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strGradeName",             DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginDate",         DBType.adVarChar,  DBNull.Value,  19,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginIP",           DBType.adVarChar,  DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPwdUpdDate",            DBType.adVarChar,  DBNull.Value,  19,   ParameterDirection.Output);
                                                                                                                      
                lo_objDas.AddParam("@po_strExpireYMD",             DBType.adVarChar,  DBNull.Value,  10,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessCenterCode",      DBType.adVarChar,  DBNull.Value,  512,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessCorpNo",          DBType.adVarChar,  DBNull.Value,  512,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetwork24DDID",         DBType.adVarChar,  DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHMMID",          DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                                                                   
                lo_objDas.AddParam("@po_strNetworkOneCallID",      DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHmadangID",      DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminPosition",         DBType.adVarWChar, DBNull.Value,  50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strOrderLocationCodes",    DBType.adVarChar,  DBNull.Value,  1000, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strOrderItemCodes",        DBType.adVarChar,  DBNull.Value,  1000, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strOrderStatusCodes",      DBType.adVarChar,  DBNull.Value,  1000, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeliveryLocationCodes", DBType.adVarChar,  DBNull.Value,  1000, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strMyOrderFlag",           DBType.adChar,     DBNull.Value,  1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,  DBNull.Value,  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,  DBNull.Value,  0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,  DBNull.Value,  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,  DBNull.Value,  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_SESSION_TX_GET", bReuseSocket);


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

                lo_objResult.data = new AdminSessionInfo
                {
                    AdminID               = lo_objDas.GetParam("@po_strAdminID"),
                    MobileNo              = lo_objDas.GetParam("@po_strMobileNo"),
                    AdminName             = lo_objDas.GetParam("@po_strAdminName"),
                    PrivateAvailFlag      = lo_objDas.GetParam("@po_strPrivateAvailFlag"),
                    DeptName              = lo_objDas.GetParam("@po_strDeptName"),
                    TelNo                 = lo_objDas.GetParam("@po_strTelNo"),
                    Email                 = lo_objDas.GetParam("@po_strEmail"),
                    WebTemplate           = lo_objDas.GetParam("@po_strWebTemplate"),
                    GradeCode             = lo_objDas.GetParam("@po_intGradeCode").ToInt(),
                    GradeName             = lo_objDas.GetParam("@po_strGradeName"),
                    LastLoginDate         = lo_objDas.GetParam("@po_strLastLoginDate"),
                    LastLoginIP           = lo_objDas.GetParam("@po_strLastLoginIP"),
                    PwdUpdDate            = lo_objDas.GetParam("@po_strPwdUpdDate"),
                    AccessCenterCode      = lo_objDas.GetParam("@po_strAccessCenterCode"),
                    AccessCorpNo          = lo_objDas.GetParam("@po_strAccessCorpNo"),
                    Network24DDID         = lo_objDas.GetParam("@po_strNetwork24DDID"),
                    NetworkHMMID          = lo_objDas.GetParam("@po_strNetworkHMMID"),
                    NetworkOneCallID      = lo_objDas.GetParam("@po_strNetworkOneCallID"),
                    NetworkHmadangID      = lo_objDas.GetParam("@po_strNetworkHmadangID"),
                    ExpireYmd             = lo_objDas.GetParam("@po_strExpireYMD"),
                    Position              = lo_objDas.GetParam("@po_strAdminPosition"),
                    OrderLocationCodes    = lo_objDas.GetParam("@po_strOrderLocationCodes"),
                    OrderItemCodes        = lo_objDas.GetParam("@po_strOrderItemCodes"),
                    OrderStatusCodes      = lo_objDas.GetParam("@po_strOrderStatusCodes"),
                    DeliveryLocationCodes = lo_objDas.GetParam("@po_strDeliveryLocationCodes"),
                    MyOrderFlag           = lo_objDas.GetParam("@po_strMyOrderFlag")
                };

                if ((lo_objResult.data.GradeCode == 0 || lo_objResult.data.GradeCode >= 3) && string.IsNullOrWhiteSpace(lo_objResult.data.AccessCenterCode))
                {
                    lo_objResult.data.AccessCenterCode = "NULL";
                }

                if (lo_objResult.data.GradeCode <= 4 && string.IsNullOrWhiteSpace(lo_objResult.data.AccessCorpNo))
                {
                    lo_objResult.data.AccessCorpNo = "NULL";
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to verifying session)" + ex.Message);
            }
            finally
            {
                if (bReuseSocket.Equals(false) &&  lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminSession RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<AdminMenuChk> CheckAdminMenu(ref IDasNetCom objDas, string strAdminID, int intGradeCode, string strMenuLink)
        {
            bool bReuseSocket = false;
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[CheckAdminMenu REQ] {strAdminID}/{intGradeCode}/{strMenuLink}", bLogWrite);

            ServiceResult<AdminMenuChk> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                if (objDas != null)
                {
                    lo_objDas    = objDas;
                    bReuseSocket = true;
                }
                else
                {
                    lo_objDas = new IDasNetCom();
                    lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                }

                lo_objResult = new ServiceResult<AdminMenuChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",   DBType.adVarChar, strAdminID,   50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode", DBType.adTinyInt, intGradeCode, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMenuLink",  DBType.adVarChar, strMenuLink,  100, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intAuthCode",  DBType.adTinyInt, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",    DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",    DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",  DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",  DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ACCESS_NT_CHK", bReuseSocket);

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

                lo_objResult.data = new AdminMenuChk
                {
                    AuthCode = lo_objDas.GetParam("@po_intAuthCode").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(CheckAdminMenu) " + ex.Message);
            }
            finally
            {
                if (bReuseSocket.Equals(false) && lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[CheckAdminMenu RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<AdminPwdInfo> GetCurrentPassword(string strAdminID)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetCurrentPassword REQ] {strAdminID}", bLogWrite);

            ServiceResult<AdminPwdInfo> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminPwdInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar, strAdminID,   50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strAdminPwd",          DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTodayLoginFailCnt", DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAdminLogInTryCnt",  DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGradeCode",         DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strUseFlag",           DBType.adChar,    DBNull.Value, 1,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_PWD_NT_GET");

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

                lo_objResult.data = new AdminPwdInfo
                {
                    CurrPassword      = lo_objDas.GetParam("@po_strAdminPwd"),
                    TodayLoginFailCnt = lo_objDas.GetParam("@po_intTodayLoginFailCnt").ToInt(),
                    AdminLogInTryCnt  = lo_objDas.GetParam("@po_intAdminLogInTryCnt").ToInt(),
                    GradeCode         = lo_objDas.GetParam("@po_intGradeCode").ToInt(),
                    UseFlag           = lo_objDas.GetParam("@po_strUseFlag")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCurrentPassword) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetCurrentPassword RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 사업자번호 체크
        /// </summary>
        /// <param name="strCorpNo">사업자번호</param>
        /// <param name="strMemberType">멤버타입</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<CorpNoCheck> GetCorpNoCheck(string strCorpNo, string strMemberType)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetCorpNoCheck REQ] {strCorpNo}/{strMemberType}", bLogWrite);

            ServiceResult<CorpNoCheck> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CorpNoCheck>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCorpNo",     DBType.adVarChar,  strCorpNo,     20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMemberType", DBType.adVarChar,  strMemberType, 5,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strExistsFlag", DBType.adChar,     DBNull.Value,  1,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCorpName",   DBType.adVarWChar, DBNull.Value,  50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,  256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CORP_NO_NT_CHK");

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

                lo_objResult.data = new CorpNoCheck
                {
                    ExistsFlag = lo_objDas.GetParam("@po_strExistsFlag"),
                    CorpName   = lo_objDas.GetParam("@po_strCorpName")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCorpNoCheck)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetCorpNoCheck RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Get previous 3 passwords from DB
        /// </summary>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<AdminPrevPwdInfo> GetPrevPassword(string strAdminID)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetPrevPassword REQ] {strAdminID}", bLogWrite);

            string                          lo_strTmpPwd = string.Empty;
            ServiceResult<AdminPrevPwdInfo> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminPrevPwdInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar, strAdminID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strAdminPrevPwds", DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger, DBNull.Value,   4,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger, DBNull.Value,   4,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_PWD_HIST_NT_GET");

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

                lo_strTmpPwd = Convert.ToString(lo_objDas.GetParam("@po_strAdminPrevPwds"));
                if (!string.IsNullOrEmpty(lo_strTmpPwd))
                {
                    lo_objResult.data = new AdminPrevPwdInfo
                    {
                        arrPrevPassword = lo_strTmpPwd.Split(',')
                    };
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPrevPassword) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetPrevPassword RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        /// Insert password reset log into DB
        /// </summary>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <param name="strIPAddr">Accessed IP Address</param>
        /// <param name="strAdminEmail">Email Address</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<PasswordReset> InsertPasswordReset(string strAdminID, string strIPAddr, string strAdminEmail)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsertPasswordReset REQ] {strAdminID}/{strIPAddr}/{strAdminEmail}", bLogWrite);

            ServiceResult<PasswordReset> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<PasswordReset>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",  DBType.adVarChar, strAdminID,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strIPAddr",   DBType.adVarChar, strIPAddr,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEamil",    DBType.adVarChar, strAdminEmail, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strToken",    DBType.adVarChar, DBNull.Value,  36,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",   DBType.adVarChar, DBNull.Value,  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",   DBType.adInteger, DBNull.Value,  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value,  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value,  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_PWD_RESET_TX_INS");

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

                lo_objResult.data = new PasswordReset
                {
                    Token           = lo_objDas.GetParam("@po_strToken"),
                    UseLangTypeCode = lo_objDas.GetParam("@po_intUseLangTypeCode").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(InsertPasswordReset)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsertPasswordReset RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check a token to verify an administrator
        /// </summary>
        /// <param name="strIPAddr">Accessed IP Address</param>
        /// <param name="strToken">Token</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<PasswordReset> CheckPasswordReset(string strIPAddr, string strToken)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[CheckPasswordReset REQ] {strIPAddr}/{strToken}", bLogWrite);

            string                       lo_strDecToken = string.Empty;
            ServiceResult<PasswordReset> lo_objResult   = null;
            IDasNetCom                   lo_objDas      = null;

            try
            {
                lo_objResult = new ServiceResult<PasswordReset>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //Decrypt token value
                lo_strDecToken =  CommonUtils.Utils.GetDecrypt(strToken);
                if (string.IsNullOrWhiteSpace(lo_strDecToken))
                {
                    lo_objResult.result.ErrorCode = ErrorHandler.COMMON_LIB_ERR_22013;
                    lo_objResult.result.ErrorMsg  = ErrorHandler.COMMON_LIB_ERR_22013_MSG;
                    return lo_objResult;
                }

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strIPAddr",          DBType.adVarChar, strIPAddr,      50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToken",           DBType.adVarChar, lo_strDecToken, 36,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strAdminID",         DBType.adVarChar, DBNull.Value,   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger, DBNull.Value,   0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger, DBNull.Value,   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_PWD_RESET_NT_CHK");

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

                lo_objResult.data = new PasswordReset
                {
                    UseLangTypeCode = lo_objDas.GetParam("@po_intUseLangTypeCode").ToInt(),
                    AdminID         = lo_objDas.GetParam("@po_strAdminID")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(CheckPasswordReset)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[CheckPasswordReset RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<PasswordReset> GetAdminIDByMObileNo(string strIdMobileNo, string strIdAdminName, string strIdAdminCorpNo, int intGradeFlag)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminIDByMObileNo REQ] {strIdMobileNo}/{strIdAdminName}/{strIdAdminCorpNo}/{intGradeFlag}", bLogWrite);

            ServiceResult<PasswordReset> lo_objResult   = null;
            IDasNetCom                   lo_objDas      = null;

            string lo_strIdMobileNo = strIdMobileNo.Replace("-", "").Replace(" ", "");

            try
            {
                lo_objResult = new ServiceResult<PasswordReset>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMobileNo",       DBType.adVarChar,  lo_strIdMobileNo,    20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",      DBType.adVarWChar, strIdAdminName,      50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminCorpNo",    DBType.adVarWChar, strIdAdminCorpNo,    20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeFlag",      DBType.adTinyInt,  intGradeFlag,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strAdminID",        DBType.adVarChar,  DBNull.Value,        50,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,  DBNull.Value,        256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,  DBNull.Value,        0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,  DBNull.Value,        256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,  DBNull.Value,        0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMINID_APP_BY_MOBILENO_NT_GET");

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

                lo_objResult.data = new PasswordReset
                {
                    AdminID = lo_objDas.GetParam("@po_strAdminID")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminIDByMObileNo) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminIDByMObileNo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Insert password reset log into DB
        /// </summary>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <param name="strIPAddr">Accessed IP Address</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<AdminSessionInfo> InsAdminSession(string strAdminID, string strIPAddr)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsertAdminSession REQ] {strAdminID}/{strIPAddr}", bLogWrite);

            ServiceResult<AdminSessionInfo> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminSessionInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,    strAdminID,      50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strIPAddr",        DBType.adVarChar,    strIPAddr,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strSessionKey",    DBType.adVarChar,    DBNull.Value,    50,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginDate", DBType.adVarChar,    DBNull.Value,    19,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginIP",   DBType.adVarChar,    DBNull.Value,    50,     ParameterDirection.Output);
                                                                                                         
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,    DBNull.Value,    256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,    DBNull.Value,    0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,    DBNull.Value,    256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,    DBNull.Value,    0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_SESSION_TX_INS");

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

                lo_objResult.data = new AdminSessionInfo
                {
                    SessionKey = lo_objDas.GetParam("@po_strSessionKey")
                };

                if (null != lo_objDas.GetParam("@po_strLastLoginDate"))
                {
                    lo_objResult.data.LastLoginDate = lo_objDas.GetParam("@po_strLastLoginDate");
                    lo_objResult.data.LastLoginIP   = CommonUtils.Utils.IsNull(lo_objDas.GetParam("@po_strLastLoginIP"), "");
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(InsertAdminSession)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsertAdminSession RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 어드민 왼쪽 메뉴 그룹 리스트
        /// </summary>
        public ServiceResult<ResAdminLeftMenuGroupList> GetAdminLeftMenuGroupList(ref IDasNetCom objDas, ReqAdminLeftMenuList objReqAdminLeftMenuList)
        {
            bool bReuseSocket = false;
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuGroupList REQ] {JsonConvert.SerializeObject(objReqAdminLeftMenuList)}", bLogWrite);
            
            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResAdminLeftMenuGroupList> lo_objResult = null;

            if (objDas != null)
            {
                bReuseSocket = true;
            }

            try
            {
                lo_objResult = new ServiceResult<ResAdminLeftMenuGroupList>(CommonConstant.DAS_RET_VAL_CODE);
                objDas.CommandType = CommandType.StoredProcedure;

                objDas.AddParam("@pi_strAdminID",       DBType.adVarChar, objReqAdminLeftMenuList.AdminID,       50, ParameterDirection.Input);
                objDas.AddParam("@pi_intMenuGroupKind", DBType.adTinyInt, objReqAdminLeftMenuList.MenuGroupKind, 0,  ParameterDirection.Input);

                objDas.SetQuery("dbo.UP_ADMIN_LEFTMENU_GROUP_AR_LST", bReuseSocket);

                //DAS 통신 실패이면 오류로 리턴
                if (objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{objDas.LastErrorCode}]{objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminLeftMenuGroupList
                {
                    list = new List<AdminLeftMenuGroupList>(),
                    RecordCnt = objDas.RecordCount
                };

                if (objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminLeftMenuGroupList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminLeftMenuGroupList)" + ex.Message);
            }
            finally
            {
                if (bReuseSocket.Equals(false) && objDas != null)
                {
                    objDas.CloseTable();
                    objDas.Close();
                    objDas = null;
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuGroupList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 어드민 왼쪽 메뉴 리스트
        /// </summary>
        public ServiceResult<ResAdminLeftMenuList> GetAdminLeftMenuList(ReqAdminLeftMenuList objReqAdminLeftMenuList)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuList REQ] {JsonConvert.SerializeObject(objReqAdminLeftMenuList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResAdminLeftMenuList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminLeftMenuList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intMenuGroupNo", DBType.adSmallInt, objReqAdminLeftMenuList.MenuGroupNo, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objReqAdminLeftMenuList.AdminID,     50, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_LEFTMENU_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminLeftMenuList
                {
                    list      = new List<AdminLeftMenuList>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminLeftMenuList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminLeftMenuList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 어드민 리스트
        /// </summary>
        public ServiceResult<ResAdminList> GetAdminList(ReqAdminList objReqAdminList)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminList REQ] {JsonConvert.SerializeObject(objReqAdminList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResAdminList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,  objReqAdminList.AdminID,          50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMobileNo",         DBType.adVarChar,  objReqAdminList.MobileNo,         20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",        DBType.adVarWChar, objReqAdminList.AdminName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,  objReqAdminList.GradeCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,     objReqAdminList.UseFlag,          1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intSesGradeCode",     DBType.adInteger,  objReqAdminList.SesGradeCode,     0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqAdminList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,  objReqAdminList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,  objReqAdminList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,  DBNull.Value,                     0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminList
                {
                    list      = new List<AdminViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<AdminViewModel> GetAdminInfo(string strAdminID)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminInfo REQ] {strAdminID}", bLogWrite);

            ServiceResult<AdminViewModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",               DBType.adVarChar,     strAdminID,      50,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strMobileNo",              DBType.adVarChar,     DBNull.Value,    20,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminName",             DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGradeCode",             DBType.adTinyInt,     DBNull.Value,    0,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strGradeName",             DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strAdminCorpNo",           DBType.adVarChar,     DBNull.Value,    20,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminCorpName",         DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPrivateAvailFlag",      DBType.adChar,        DBNull.Value,    1,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeptName",              DBType.adVarWChar,    DBNull.Value,    256,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strTelNo",                 DBType.adVarChar,     DBNull.Value,    20,       ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strEmail",                 DBType.adVarWChar,    DBNull.Value,    100,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strWebTemplate",           DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessIPChkFlag",       DBType.adChar,        DBNull.Value,    1,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessIP1",             DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessIP2",             DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strAccessIP3",             DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginDate",         DBType.adVarChar,     DBNull.Value,    19,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLastLoginIP",           DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strJoinYMD",               DBType.adVarChar,     DBNull.Value,    8,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strExpireYMD",             DBType.adVarChar,     DBNull.Value,    8,        ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strPwdUpdDate",            DBType.adVarChar,     DBNull.Value,    19,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessCenterCode",      DBType.adVarChar,     DBNull.Value,    512,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAccessCorpNo",          DBType.adVarChar,     DBNull.Value,    512,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetwork24DDID",         DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHMMID",          DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strNetworkOneCallID",      DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHmadangID",      DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminPosition",         DBType.adVarWChar,    DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strOrderLocationCodes",    DBType.adVarChar,     DBNull.Value,    1000,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strOrderItemCodes",        DBType.adVarChar,     DBNull.Value,    1000,     ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_strOrderStatusCodes",      DBType.adVarChar,     DBNull.Value,    1000,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeliveryLocationCodes", DBType.adVarChar,     DBNull.Value,    1000,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strMyOrderFlag",           DBType.adChar,        DBNull.Value,    1,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDupLoginFlag",          DBType.adChar,        DBNull.Value,    1,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strUseFlag",               DBType.adChar,        DBNull.Value,    1,        ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_intRegReqType",            DBType.adTinyInt,     DBNull.Value,    0,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegAdminID",            DBType.adVarChar,     DBNull.Value,    50,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,     DBNull.Value,    256,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,     DBNull.Value,    0,        ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,     DBNull.Value,    256,      ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,     DBNull.Value,    0,        ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_NT_GET");

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

                lo_objResult.data = new AdminViewModel
                {
                    MobileNo              = lo_objDas.GetParam("@po_strMobileNo"),
                    AdminName             = lo_objDas.GetParam("@po_strAdminName"),
                    GradeCode             = lo_objDas.GetParam("@po_intGradeCode").ToInt(),
                    GradeName             = lo_objDas.GetParam("@po_strGradeName"),
                    AdminCorpNo           = lo_objDas.GetParam("@po_strAdminCorpNo"),
                    AdminCorpName         = lo_objDas.GetParam("@po_strAdminCorpName"),
                    PrivateAvailFlag      = lo_objDas.GetParam("@po_strPrivateAvailFlag"),
                    DeptName              = lo_objDas.GetParam("@po_strDeptName"),
                    TelNo                 = lo_objDas.GetParam("@po_strTelNo"),
                    Email                 = lo_objDas.GetParam("@po_strEmail"),
                    WebTemplate           = lo_objDas.GetParam("@po_strWebTemplate"),
                    AccessIPChkFlag       = lo_objDas.GetParam("@po_strAccessIPChkFlag"),
                    AccessIP1             = lo_objDas.GetParam("@po_strAccessIP1"),
                    AccessIP2             = lo_objDas.GetParam("@po_strAccessIP2"),
                    AccessIP3             = lo_objDas.GetParam("@po_strAccessIP3"),
                    LastLoginDate         = lo_objDas.GetParam("@po_strLastLoginDate"),
                    LastLoginIP           = lo_objDas.GetParam("@po_strLastLoginIP"),
                    JoinYMD               = lo_objDas.GetParam("@po_strJoinYMD"),
                    ExpireYMD             = lo_objDas.GetParam("@po_strExpireYMD"),
                    PwdUpdDate            = lo_objDas.GetParam("@po_strPwdUpdDate"),
                    AccessCenterCode      = lo_objDas.GetParam("@po_strAccessCenterCode"),
                    AccessCorpNo          = lo_objDas.GetParam("@po_strAccessCorpNo"),
                    Network24DDID         = lo_objDas.GetParam("@po_strNetwork24DDID"),
                    NetworkHMMID          = lo_objDas.GetParam("@po_strNetworkHMMID"),
                    NetworkOneCallID      = lo_objDas.GetParam("@po_strNetworkOneCallID"),
                    NetworkHmadangID      = lo_objDas.GetParam("@po_strNetworkHmadangID"),
                    AdminPosition         = lo_objDas.GetParam("@po_strAdminPosition"),
                    OrderLocationCodes    = lo_objDas.GetParam("@po_strOrderLocationCodes"),
                    OrderItemCodes        = lo_objDas.GetParam("@po_strOrderItemCodes"),
                    OrderStatusCodes      = lo_objDas.GetParam("@po_strOrderStatusCodes"),
                    DeliveryLocationCodes = lo_objDas.GetParam("@po_strDeliveryLocationCodes"),
                    MyOrderFlag           = lo_objDas.GetParam("@po_strMyOrderFlag"),
                    DupLoginFlag          = lo_objDas.GetParam("@po_strDupLoginFlag"),
                    UseFlag               = lo_objDas.GetParam("@po_strUseFlag"),
                    RegReqType            = lo_objDas.GetParam("@po_intRegReqType").ToInt(),
                    RegAdminID            = lo_objDas.GetParam("@po_strRegAdminID")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminInfo) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdAdminPwd(string strAdminID, string  strEncAdminResetPwd, string strRegAdminID, int intResetFlag)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminPwd REQ] {strAdminID}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar, strAdminID,             50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminPwdNew",   DBType.adVarChar, strEncAdminResetPwd,    256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",    DBType.adVarChar, strRegAdminID,          50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intResetFlag",     DBType.adTinyInt, intResetFlag,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar, DBNull.Value,           256,    ParameterDirection.Output);
                                                                                                             
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger, DBNull.Value,           0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar, DBNull.Value,           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger, DBNull.Value,           0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_PWD_TX_UPD");

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
                                     , 9101, "System error(UpdAdminPwd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminPwd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsAdmin(AdminViewModel objInsAdmin)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdmin REQ] {JsonConvert.SerializeObject(objInsAdmin)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,  objInsAdmin.AdminID,              50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminPwd",           DBType.adVarChar,  objInsAdmin.AdminPwd,             256,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMobileNo",           DBType.adVarChar,  objInsAdmin.MobileNo,             20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",          DBType.adVarWChar, objInsAdmin.AdminName,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,  objInsAdmin.GradeCode,            0,     ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strAdminCorpNo",        DBType.adVarChar,  objInsAdmin.AdminCorpNo,          20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminCorpName",      DBType.adVarWChar, objInsAdmin.AdminCorpName,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPrivateAvailFlag",   DBType.adChar,     objInsAdmin.PrivateAvailFlag,     1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeptName",           DBType.adVarWChar, objInsAdmin.DeptName,             256,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",              DBType.adVarChar,  objInsAdmin.TelNo,                20,    ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strEmail",              DBType.adVarWChar, objInsAdmin.Email,                100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminPosition",      DBType.adVarWChar, objInsAdmin.AdminPosition,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWebTemplate",        DBType.adVarChar,  objInsAdmin.WebTemplate,          50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIPChkFlag",    DBType.adChar,     objInsAdmin.AccessIPChkFlag,      1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIP1",          DBType.adVarChar,  objInsAdmin.AccessIP1,            50,    ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strAccessIP2",          DBType.adVarChar,  objInsAdmin.AccessIP2,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIP3",          DBType.adVarChar,  objInsAdmin.AccessIP3,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strExpireYMD",          DBType.adVarChar,  objInsAdmin.ExpireYMD,            8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,  objInsAdmin.AccessCenterCode,     512,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,  objInsAdmin.AccessCorpNo,         512,   ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strNetwork24DDID",      DBType.adVarChar,  objInsAdmin.Network24DDID,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHMMID",       DBType.adVarWChar, objInsAdmin.NetworkHMMID,         50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOneCallID",   DBType.adVarWChar, objInsAdmin.NetworkOneCallID,     50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHmadangID",   DBType.adVarWChar, objInsAdmin.NetworkHmadangID,     50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDupLoginFlag",       DBType.adChar,     objInsAdmin.DupLoginFlag,         1,     ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strMyOrderFlag",        DBType.adChar,     objInsAdmin.MyOrderFlag,          1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,     objInsAdmin.UseFlag,              1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRegReqType",         DBType.adTinyInt,  objInsAdmin.RegReqType,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,  objInsAdmin.RegAdminID,           50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,  DBNull.Value,                     256,   ParameterDirection.Output);
                                                                                                                            
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,  DBNull.Value,                     0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,  DBNull.Value,                     256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,  DBNull.Value,                     0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_TX_INS");

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
                                     , 9101, "System error(InsAdmin)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdmin RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdAdmin(AdminViewModel objUpdAdmin)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdmin REQ] {JsonConvert.SerializeObject(objUpdAdmin)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,  objUpdAdmin.AdminID,              50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMobileNo",         DBType.adVarChar,  objUpdAdmin.MobileNo,             20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",        DBType.adVarWChar, objUpdAdmin.AdminName,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,  objUpdAdmin.GradeCode,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminCorpNo",      DBType.adVarChar,  objUpdAdmin.AdminCorpNo,          20,  ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strAdminCorpName",    DBType.adVarWChar, objUpdAdmin.AdminCorpName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPrivateAvailFlag", DBType.adChar,     objUpdAdmin.PrivateAvailFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeptName",         DBType.adVarWChar, objUpdAdmin.DeptName,             256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",            DBType.adVarChar,  objUpdAdmin.TelNo,                20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEmail",            DBType.adVarWChar, objUpdAdmin.Email,                100, ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strAdminPosition",    DBType.adVarWChar, objUpdAdmin.AdminPosition,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWebTemplate",      DBType.adVarChar,  objUpdAdmin.WebTemplate,          50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIPChkFlag",  DBType.adChar,     objUpdAdmin.AccessIPChkFlag,      1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIP1",        DBType.adVarChar,  objUpdAdmin.AccessIP1,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessIP2",        DBType.adVarChar,  objUpdAdmin.AccessIP2,            50,  ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strAccessIP3",        DBType.adVarChar,  objUpdAdmin.AccessIP3,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strExpireYMD",        DBType.adVarChar,  objUpdAdmin.ExpireYMD,            8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objUpdAdmin.AccessCenterCode,     512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,  objUpdAdmin.AccessCorpNo,         512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetwork24DDID",    DBType.adVarChar,  objUpdAdmin.Network24DDID,        50,  ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strNetworkHMMID",     DBType.adVarWChar, objUpdAdmin.NetworkHMMID,         50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOneCallID", DBType.adVarWChar, objUpdAdmin.NetworkOneCallID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHmadangID", DBType.adVarWChar, objUpdAdmin.NetworkHmadangID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRegReqType",       DBType.adTinyInt,  objUpdAdmin.RegReqType,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDupLoginFlag",     DBType.adChar,     objUpdAdmin.DupLoginFlag,         1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMyOrderFlag",      DBType.adChar,     objUpdAdmin.MyOrderFlag,          1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,     objUpdAdmin.UseFlag,              1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",       DBType.adVarChar,  objUpdAdmin.RegAdminID,           50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,  DBNull.Value,                     256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,  DBNull.Value,                     0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,  DBNull.Value,                     256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,  DBNull.Value,                     0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_TX_UPD");

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
                                     , 9101, "System error(UpdAdmin)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdmin RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 로그인 실패 초기화
        /// </summary>
        /// <param name="strAdminID"></param>
        /// <returns></returns>
        public ServiceResult<bool> ResetLoginAdmin(string strAdminID)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[LoginResetAdmin REQ] {strAdminID}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar, strAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intResetFlag",    DBType.adTinyInt, 2,                0,       ParameterDirection.Input);  // 1:로그인, 2:RESET
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar, DBNull.Value,     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger, DBNull.Value,     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar, DBNull.Value,     256,     ParameterDirection.Output);
                                                                                                       
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger, DBNull.Value,     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_LOGIN_FAIL_RESET_TX_UPD");

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
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(LoginResetAdmin)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[LoginResetAdmin RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리자 메뉴 접근 리스트
        /// </summary>
        /// <param name="strAdminId"></param>
        /// <returns></returns>
        public ServiceResult<ResAdminMenuAccessList> GetAdminMenuAccessList(string strAdminId)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminMenuAccessList REQ] {strAdminId}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResAdminMenuAccessList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuAccessList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID", DBType.adVarChar, strAdminId, 0, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ACCESS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuAccessList
                {
                    list      = new List<AdminMenuAccessViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuAccessViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(GetAdminMenuAccessList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminMenuAccessList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리자 메뉴 접근 메뉴 역할 리스트
        /// </summary>
        /// <param name="strAdminId"></param>
        /// <returns></returns>
        public ServiceResult<ResAdminMenuRoleAccessList> GetAdminMenuRoleAccessList(string strAdminId)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminMenuRoleAccessList REQ] {strAdminId}", bLogWrite);

            string                                    lo_strJson   = string.Empty;
            ServiceResult<ResAdminMenuRoleAccessList> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminMenuRoleAccessList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID", DBType.adVarChar, strAdminId, 0, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ROLE_ACCESS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminMenuRoleAccessList
                {
                    list      = new List<AdminMenuRoleAccessViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminMenuRoleAccessViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(GetAdminMenuRoleAccessList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminMenuRoleAccessList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

       
        public ServiceResult<bool> InsMenuAccessAdmin(AdminMenuAccessViewModel objAdminMenuAccessViewModel)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsMenuAccessAdmin REQ] {JsonConvert.SerializeObject(objAdminMenuAccessViewModel)}", bLogWrite);
            
            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar, objAdminMenuAccessViewModel.AdminID,        50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAccessTypeCode", DBType.adTinyInt, objAdminMenuAccessViewModel.AccessTypeCode, 0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddMenuList",    DBType.adVarChar, objAdminMenuAccessViewModel.AddMenuList,    4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRmMenuList",     DBType.adVarChar, objAdminMenuAccessViewModel.RmMenuList,     4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllAuthCode",    DBType.adVarChar, objAdminMenuAccessViewModel.AllAuthCode,    4000,   ParameterDirection.Input);
                                                                                                                                  
                lo_objDas.AddParam("@pi_strRwAuthCode",     DBType.adVarChar, objAdminMenuAccessViewModel.RwAuthCode,     4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRoAuthCode",     DBType.adVarChar, objAdminMenuAccessViewModel.RoAuthCode,     4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar, DBNull.Value,                               256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger, DBNull.Value,                               0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar, DBNull.Value,                               256,    ParameterDirection.Output);
                                                                                                                                  
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger, DBNull.Value,                               0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MENU_ACCESS_TX_INS");

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
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(InsMenuAccessAdmin)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsMenuAccessAdmin RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 관리자 내정보 수정
        /// </summary>
        /// <param name="UpdAdminMyInfo"></param>
        /// <returns></returns>
        public ServiceResult<bool> UpdAdminMyInfo(AdminViewModel objUpdAdminMyInfo)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminMyInfo REQ] {JsonConvert.SerializeObject(objUpdAdminMyInfo)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,  objUpdAdminMyInfo.AdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMobileNo",          DBType.adVarChar,  objUpdAdminMyInfo.MobileNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminPosition",     DBType.adVarWChar, objUpdAdminMyInfo.AdminPosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeptName",          DBType.adVarWChar, objUpdAdminMyInfo.DeptName,          256,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",             DBType.adVarChar,  objUpdAdminMyInfo.TelNo,             20,      ParameterDirection.Input);
                                                                                                                                
                lo_objDas.AddParam("@pi_strNetwork24DDID",     DBType.adVarChar,  objUpdAdminMyInfo.Network24DDID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHMMID",      DBType.adVarWChar, objUpdAdminMyInfo.NetworkHMMID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOneCallID",  DBType.adVarWChar, objUpdAdminMyInfo.NetworkOneCallID,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHmadangID",  DBType.adVarWChar, objUpdAdminMyInfo.NetworkHmadangID,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEmail",             DBType.adVarWChar, objUpdAdminMyInfo.Email,             100,     ParameterDirection.Input);
                                                                                                                                
                lo_objDas.AddParam("@pi_strUseFlag",           DBType.adChar,     objUpdAdminMyInfo.UseFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,  DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,  DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,  DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,  DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_MYINFO_TX_UPD");

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
                                     , 9101, "System error(fail to update admin's myinfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminMyInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 어드민 리스트
        /// </summary>
        public ServiceResult<ResAdminList> GetAdminClientList(ReqAdminList objReqAdminList)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminClientList REQ] {JsonConvert.SerializeObject(objReqAdminList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResAdminList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqAdminList.AdminID,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqAdminList.CenterCode, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,    objReqAdminList.ClientCode, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objReqAdminList.UseFlag,    1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,   objReqAdminList.PageSize,   0,    ParameterDirection.Input);
                                                                                                                  
                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,   objReqAdminList.PageNo,     0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,               0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminList
                {
                    list      = new List<AdminViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9301, "System error(GetAdminClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 웹오더 알림 수신 업체 등록
        /// </summary>
        /// <param name="InsAdminClient"></param>
        /// <returns></returns>
        public ServiceResult<bool> InsAdminClient(AdminViewModel objUpdAdminMyInfo)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminClient REQ] {JsonConvert.SerializeObject(objUpdAdminMyInfo)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,   objUpdAdminMyInfo.AdminID,      0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objUpdAdminMyInfo.CenterCode,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode", DBType.adBigInt,    objUpdAdminMyInfo.ClientCode,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID", DBType.adVarChar,   objUpdAdminMyInfo.AdminID,      50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                   256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                   0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                   256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                   0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_CLIENT_TX_INS");

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
                                     , 9101, "System error(fail to update admin's myinfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[InsAdminClient RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 웹오더 알림 수신 업체 수정
        /// </summary>
        /// <param name="UpdAdminClient"></param>
        /// <returns></returns>
        public ServiceResult<bool> UpdAdminClient(AdminViewModel objUpdAdminMyInfo)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminClient REQ] {JsonConvert.SerializeObject(objUpdAdminMyInfo)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",          DBType.adInteger,   objUpdAdminMyInfo.SeqNo,        0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objUpdAdminMyInfo.UseFlag,      1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objUpdAdminMyInfo.AdminID,      50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                   256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                   0,     ParameterDirection.Output);
                                                            
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                   256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                   0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_CLIENT_TX_UPD");

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
                                     , 9101, "System error(fail to update admin's myinfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[UpdAdminClient RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResAdminLeftMenuAllList> GetAdminLeftMenuAllList(string strAdminID)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuAllList REQ] {strAdminID}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResAdminLeftMenuAllList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objDas = new IDasNetCom();
                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);

                lo_objResult          = new ServiceResult<ResAdminLeftMenuAllList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID", DBType.adVarChar, strAdminID, 50, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ADMIN_LEFTMENU_ALL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminLeftMenuAllList
                {
                    list      = new List<AdminLeftMenuAllList>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminLeftMenuAllList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminLeftMenuGroupList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetAdminLeftMenuAllList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 관리자 검색조건 저장
        /// </summary>
        /// <param name="objAdminCodesModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetUpdAdminCodes(AdminCodesModel objAdminCodesModel)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[SetUpdAdminCodes REQ] {JsonConvert.SerializeObject(objAdminCodesModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objAdminCodesModel.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objAdminCodesModel.OrderLocationCodes,     1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objAdminCodesModel.OrderItemCodes,         1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderStatusCodes",       DBType.adVarChar,   objAdminCodesModel.OrderStatusCodes,       1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",  DBType.adVarChar,   objAdminCodesModel.DeliveryLocationCodes,  1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_CODES_TX_UPD");

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
                                     , 9101, "System error(SetUpdAdminCodes)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[SetUpdAdminCodes RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}