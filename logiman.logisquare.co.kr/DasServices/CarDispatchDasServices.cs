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
    public class CarDispatchDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 차량조회 리스트
        /// </summary>
        public ServiceResult<ResCarDispatchList> GetCarDispatchList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intRefSeqNo",           DBType.adBigInt,    objCarDispatchList.RefSeqNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objCarDispatchList.CenterCode,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",         DBType.adVarChar,   objCarDispatchList.DriverCell,        20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",         DBType.adVarWChar,  objCarDispatchList.DriverName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",          DBType.adVarChar,   objCarDispatchList.ComCorpNo,         20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComName",            DBType.adVarWChar,  objCarDispatchList.ComName,           50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCeoName",         DBType.adVarWChar,  objCarDispatchList.ComCeoName,        30,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",              DBType.adVarWChar,  objCarDispatchList.CarNo,             20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",         DBType.adTinyInt,   objCarDispatchList.CarDivType,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",         DBType.adVarChar,   objCarDispatchList.CarTonCode,        5,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTypeCode",        DBType.adVarChar,   objCarDispatchList.CarTypeCode,       5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCooperatorFlag",     DBType.adChar,      objCarDispatchList.CooperatorFlag,    1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCargoManFlag",       DBType.adChar,      objCarDispatchList.CargoManFlag,      1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objCarDispatchList.UseFlag,           1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,   objCarDispatchList.GradeCode,         0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objCarDispatchList.AccessCenterCode,  512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,   objCarDispatchList.AccessCorpNo,      512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objCarDispatchList.PageSize,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objCarDispatchList.PageNo,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                         0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DISPATCH_REF_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list      = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarDispatchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<CarDispatchViewModel> InsCarDispatchRef(CarDispatchViewModel objInsCarDispatchRef)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[InsCarDispatchRef REQ] {JsonConvert.SerializeObject(objInsCarDispatchRef)}", bLogWrite);

            ServiceResult<CarDispatchViewModel> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CarDispatchViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intRefSeqNo",          DBType.adInteger,   objInsCarDispatchRef.RefSeqNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objInsCarDispatchRef.CenterCode,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",        DBType.adTinyInt,   objInsCarDispatchRef.CarDivType,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarSeqNo",          DBType.adBigInt,    objInsCarDispatchRef.CarSeqNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",             DBType.adVarWChar,  objInsCarDispatchRef.CarNo,             50,   ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_strCarTypeCode",       DBType.adVarChar,   objInsCarDispatchRef.CarTypeCode,       5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarSubType",        DBType.adVarWChar,  objInsCarDispatchRef.CarSubType,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",        DBType.adVarChar,   objInsCarDispatchRef.CarTonCode,        5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarBrandCode",      DBType.adVarChar,   objInsCarDispatchRef.CarBrandCode,      5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNote",           DBType.adVarWChar,  objInsCarDispatchRef.CarNote,           500,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intComCode",           DBType.adBigInt,    objInsCarDispatchRef.ComCode,           0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",           DBType.adVarWChar,  objInsCarDispatchRef.ComName,           100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCeoName",        DBType.adVarWChar,  objInsCarDispatchRef.ComCeoName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",         DBType.adVarChar,   objInsCarDispatchRef.ComCorpNo,         20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComBizType",        DBType.adVarWChar,  objInsCarDispatchRef.ComBizType,        100,  ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_strComBizClass",       DBType.adVarWChar,  objInsCarDispatchRef.ComBizClass,       100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComTelNo",          DBType.adVarChar,   objInsCarDispatchRef.ComTelNo,          20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComFaxNo",          DBType.adVarChar,   objInsCarDispatchRef.ComFaxNo,          20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComEmail",          DBType.adVarChar,   objInsCarDispatchRef.ComEmail,          100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComPost",           DBType.adVarChar,   objInsCarDispatchRef.ComPost,           6,    ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_strComAddr",           DBType.adVarWChar,  objInsCarDispatchRef.ComAddr,           100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComAddrDtl",        DBType.adVarWChar,  objInsCarDispatchRef.ComAddrDtl,        100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComStatus",         DBType.adTinyInt,   objInsCarDispatchRef.ComStatus,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComTaxKind",        DBType.adTinyInt,   objInsCarDispatchRef.ComTaxKind,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComTaxMsg",         DBType.adVarWChar,  objInsCarDispatchRef.ComTaxMsg,         50,   ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_strCardAgreeFlag",     DBType.adChar,      objInsCarDispatchRef.CardAgreeFlag,     1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCardAgreeYMD",      DBType.adVarChar,   objInsCarDispatchRef.CardAgreeYMD,      8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",       DBType.adBigInt,    objInsCarDispatchRef.DriverSeqNo,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",        DBType.adVarWChar,  objInsCarDispatchRef.DriverName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",        DBType.adVarChar,   objInsCarDispatchRef.DriverCell,        20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPayDay",            DBType.adTinyInt,   objInsCarDispatchRef.PayDay,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankCode",          DBType.adVarChar,   objInsCarDispatchRef.BankCode,          3,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEncAcctNo",         DBType.adVarChar,   objInsCarDispatchRef.EncAcctNo,         256,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchAcctNo",      DBType.adVarChar,   objInsCarDispatchRef.SearchAcctNo,      50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctName",          DBType.adVarWChar,  objInsCarDispatchRef.AcctName,          50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAcctValidFlag",     DBType.adChar,      objInsCarDispatchRef.AcctValidFlag,     1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCooperatorFlag",    DBType.adChar,      objInsCarDispatchRef.CooperatorFlag,    1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",        DBType.adVarWChar,  objInsCarDispatchRef.ChargeName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",       DBType.adVarChar,   objInsCarDispatchRef.ChargeTelNo,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeEmail",       DBType.adVarWChar,  objInsCarDispatchRef.ChargeEmail,       100,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRefNote",           DBType.adVarWChar,  objInsCarDispatchRef.RefNote,           500,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCargoManFlag",      DBType.adChar,      objInsCarDispatchRef.CargoManFlag,      1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInsureTargetFlag",  DBType.adChar,      objInsCarDispatchRef.InsureTargetFlag,  1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDtlSeqNo",          DBType.adBigInt,    objInsCarDispatchRef.DtlSeqNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",           DBType.adChar,      DBNull.Value,                           1,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRefUseFlag",        DBType.adChar,      objInsCarDispatchRef.UseFlag,           1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,   objInsCarDispatchRef.AdminID,           50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRefSeqNo",          DBType.adBigInt,    DBNull.Value,                           0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarSeqNo",          DBType.adBigInt,    DBNull.Value,                           0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intComCode",           DBType.adBigInt,    DBNull.Value,                           0,    ParameterDirection.Output);
                                                                                                                           
                lo_objDas.AddParam("@po_intDriverSeqNo",       DBType.adBigInt,    DBNull.Value,                           0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                           256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                           0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                           256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                           0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_ALL_TX_INS");

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
                objInsCarDispatchRef.RefSeqNo = lo_objDas.GetParam("@po_intRefSeqNo").ToInt64();

                lo_objResult.data = objInsCarDispatchRef;
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
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[InsCarDispatchRef RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCarDispatchList> GetCarList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCarSeqNo",       DBType.adBigInt,    objCarDispatchList.CarSeqNo,        0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",          DBType.adVarWChar,  objCarDispatchList.CarNo,           20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchCarNo",    DBType.adVarChar,   objCarDispatchList.SearchCarNo,     4,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",    DBType.adVarChar,   objCarDispatchList.CarTypeCode,     5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",     DBType.adVarChar,   objCarDispatchList.CarTonCode,      5,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarBrandCode",   DBType.adVarChar,   objCarDispatchList.CarBrandCode,    5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",        DBType.adVarChar,   objCarDispatchList.FromYmd,         8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",          DBType.adVarChar,   objCarDispatchList.ToYmd,           8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objCarDispatchList.UseYmd,          1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,   objCarDispatchList.PageSize,        0,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,   objCarDispatchList.PageNo,          0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list      = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCarDispatchList> GetCarDriverList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDriverSeqNo",    DBType.adBigInt,    objCarDispatchList.DriverSeqNo, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",     DBType.adVarWChar,  objCarDispatchList.DriverName,  20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",     DBType.adVarChar,   objCarDispatchList.DriverCell,  5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objCarDispatchList.UseFlag,     1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",        DBType.adVarChar,   objCarDispatchList.FromYmd,     8,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strToYMD",          DBType.adVarChar,   objCarDispatchList.ToYmd,       8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,   objCarDispatchList.PageSize,    0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,   objCarDispatchList.PageNo,      0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,                   0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list      = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9104, "System error(GetCarDriverList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCarDispatchList> GetCarCompanyList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanyList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intComCode",            DBType.adBigInt,    objCarDispatchList.ComCode,             0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode", DBType.adInteger,   objCarDispatchList.ContractCenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",            DBType.adVarWChar,  objCarDispatchList.ComName,             50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCeoName",         DBType.adVarWChar,  objCarDispatchList.ComCeoName,          30,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",          DBType.adVarChar,   objCarDispatchList.ComCorpNo,           20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objCarDispatchList.UseFlag,             1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objCarDispatchList.PageSize,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objCarDispatchList.PageNo,              0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                           0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list      = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9105, "System error(GetCarCompanyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCarDispatchList> GetCarCompanyDtlList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanyDtlList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objCarDispatchList.CenterCode,      0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",        DBType.adBigInt,    objCarDispatchList.ComCode,         0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchAcctNo",   DBType.adVarChar,   objCarDispatchList.SearchAcctNo,    50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctName",       DBType.adVarWChar,  objCarDispatchList.AcctName,        50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,                       0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_DTL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9105, "System error(GetCarCompanyDtlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanyDtlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCarDispatchList> GetCarDispatchCooperatorList(ReqCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchCooperatorList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResCarDispatchList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intComCode",    DBType.adBigInt,    objCarDispatchList.ComCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objCarDispatchList.CenterCode,  0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",    DBType.adVarChar,   objCarDispatchList.ComName,     50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCeoName", DBType.adVarChar,   objCarDispatchList.ComCeoName,  30, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",  DBType.adVarChar,   objCarDispatchList.ComCorpNo,   20, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",    DBType.adChar,      objCarDispatchList.UseFlag,     1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,   objCarDispatchList.PageSize,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,   objCarDispatchList.PageNo,      0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,   DBNull.Value,                   0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_COOPERATOR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchList
                {
                    list = new List<CarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9105, "System error(GetCarDispatchCooperatorList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchCooperatorList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 차량 검색
        /// </summary>
        /// <param name="objReqCarSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarSearchList> GetCarSearchList(ReqCarSearchList objReqCarSearchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarSearchList REQ] {JsonConvert.SerializeObject(objReqCarSearchList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResCarSearchList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCarNo",        DBType.adVarWChar, objReqCarSearchList.CarNo,       20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchCarNo",  DBType.adVarChar,  objReqCarSearchList.SearchCarNo, 5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",      DBType.adChar,     objReqCarSearchList.UseFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",     DBType.adInteger,  objReqCarSearchList.PageSize,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",       DBType.adInteger,  objReqCarSearchList.PageNo,      0,   ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",    DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarSearchList
                {
                    list = new List<CarModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량 업체 검색
        /// </summary>
        /// <param name="objReqCarCompanySearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarCompanySearchList> GetCarCompanySearchList(ReqCarCompanySearchList objReqCarCompanySearchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanySearchList REQ] {JsonConvert.SerializeObject(objReqCarCompanySearchList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResCarCompanySearchList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarCompanySearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strComName",            DBType.adVarWChar,  objReqCarCompanySearchList.ComName,     50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCeoName",         DBType.adVarWChar,  objReqCarCompanySearchList.ComCeoName,  30, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",          DBType.adVarChar,   objReqCarCompanySearchList.ComCorpNo,   20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objReqCarCompanySearchList.UseFlag,     1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqCarCompanySearchList.PageSize,    0,  ParameterDirection.Input);
                                                                                                                                
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqCarCompanySearchList.PageNo,      0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                           0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarCompanySearchList
                {
                    list = new List<CarCompanyModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarCompanyModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarCompanySearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarCompanySearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 기사 검색
        /// </summary>
        /// <param name="objReqCarDriverSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarDriverSearchList> GetCarDriverSearchList(ReqCarDriverSearchList objReqCarDriverSearchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverSearchList REQ] {JsonConvert.SerializeObject(objReqCarDriverSearchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResCarDriverSearchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDriverSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strDriverName",     DBType.adVarWChar,  objReqCarDriverSearchList.DriverName, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",     DBType.adVarChar,   objReqCarDriverSearchList.DriverCell, 5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objReqCarDriverSearchList.UseFlag,    1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,   objReqCarDriverSearchList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,   objReqCarDriverSearchList.PageNo,     0,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDriverSearchList
                {
                    list = new List<CarDriverModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDriverModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarDriverSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배차차량 검색
        /// </summary>
        /// <param name="objReqCarDispatchRefSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarDispatchRefSearchList> GetCarDispatchRefSearchList(ReqCarDispatchRefSearchList objReqCarDispatchRefSearchList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchRefSearchList REQ] {JsonConvert.SerializeObject(objReqCarDispatchRefSearchList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResCarDispatchRefSearchList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                if (string.IsNullOrEmpty(objReqCarDispatchRefSearchList.SearchCarNo) && objReqCarDispatchRefSearchList.CarNo.Length >= 4)
                {
                    objReqCarDispatchRefSearchList.SearchCarNo = StringExtensions.IsNumeric(objReqCarDispatchRefSearchList.CarNo.Right(4)) ? objReqCarDispatchRefSearchList.CarNo.Right(4) : string.Empty;
                }

                lo_objResult = new ServiceResult<ResCarDispatchRefSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqCarDispatchRefSearchList.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",       DBType.adVarWChar, objReqCarDispatchRefSearchList.DriverName,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",       DBType.adVarChar,  objReqCarDispatchRefSearchList.DriverCell,       20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",          DBType.adVarWChar, objReqCarDispatchRefSearchList.ComName,          50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",        DBType.adVarChar,  objReqCarDispatchRefSearchList.ComCorpNo,        20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComCeoName",       DBType.adVarWChar, objReqCarDispatchRefSearchList.ComCeoName,       30,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",            DBType.adVarWChar, objReqCarDispatchRefSearchList.CarNo,            20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchCarNo",      DBType.adVarChar,  objReqCarDispatchRefSearchList.SearchCarNo,      20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarDivTypes",      DBType.adVarChar,  objReqCarDispatchRefSearchList.CarDivTypes,      4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,     objReqCarDispatchRefSearchList.UseFlag,          1,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,  objReqCarDispatchRefSearchList.GradeCode,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqCarDispatchRefSearchList.AccessCenterCode, 512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,  objReqCarDispatchRefSearchList.AccessCorpNo,     512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,  objReqCarDispatchRefSearchList.PageSize,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,  objReqCarDispatchRefSearchList.PageNo,           0,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,  DBNull.Value,                                    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DISPATCH_REF_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDispatchRefSearchList
                {
                    list = new List<CarDispatchRefModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDispatchRefModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarDispatchRefSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDispatchRefSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 차량업체 계좌번호 등록/수정
        /// </summary>
        /// <param name="objReqCarCompanyAcctUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCarCompanyAcctUpd(ReqCarCompanyAcctUpd objReqCarCompanyAcctUpd)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarCompanyAcctUpd REQ] {JsonConvert.SerializeObject(objReqCarCompanyAcctUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqCarCompanyAcctUpd.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",        DBType.adBigInt,    objReqCarCompanyAcctUpd.ComCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",      DBType.adVarChar,   objReqCarCompanyAcctUpd.ComCorpNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",     DBType.adVarChar,   objReqCarCompanyAcctUpd.DriverCell,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqType",        DBType.adTinyInt,   objReqCarCompanyAcctUpd.ReqType,          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBankCode",       DBType.adVarChar,   objReqCarCompanyAcctUpd.BankCode,         3,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEncAcctNo",      DBType.adVarChar,   objReqCarCompanyAcctUpd.EncAcctNo,        256,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchAcctNo",   DBType.adVarChar,   objReqCarCompanyAcctUpd.SearchAcctNo,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctName",       DBType.adVarWChar,  objReqCarCompanyAcctUpd.AcctName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctValidFlag",  DBType.adChar,      objReqCarCompanyAcctUpd.AcctValidFlag,    1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqCarCompanyAcctUpd.AdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_DTL_ACCT_TX_PROC");

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
                                     , 9101, "System error(SetCarCompanyAcctUpd) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarCompanyAcctUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 상세 차량 간편등록
        /// </summary>
        /// <param name="objCarAllManageIns"></param>
        /// <returns></returns>
        public ServiceResult<CarDispatchViewModel> SetCarAllManageIns(CarDispatchViewModel objCarAllManageIns)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[CarAllManageIns REQ] {JsonConvert.SerializeObject(objCarAllManageIns)}", bLogWrite);

            ServiceResult<CarDispatchViewModel> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CarDispatchViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",   DBType.adInteger,   objCarAllManageIns.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",   DBType.adTinyInt,   objCarAllManageIns.CarDivType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarSeqNo",     DBType.adBigInt,    objCarAllManageIns.CarSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",      DBType.adBigInt,    objCarAllManageIns.ComCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",  DBType.adBigInt,    objCarAllManageIns.DriverSeqNo,    0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar,   objCarAllManageIns.AdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRefSeqNo",     DBType.adBigInt,    DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDispatchInfo", DBType.adVarWChar,  DBNull.Value,                      200,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_ALL_MANAGE_TX_INS");

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
                objCarAllManageIns.RefSeqNo     = lo_objDas.GetParam("@po_intRefSeqNo").ToInt64();
                objCarAllManageIns.DispatchInfo = lo_objDas.GetParam("@po_strDispatchInfo");

                lo_objResult.data = objCarAllManageIns;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCarAllManageIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[CarAllManageIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 회원사별 기사 추가정보(산재보험) 등록
        /// </summary>
        /// <param name="objCarDriverDtlModel"></param>
        /// <returns></returns>
        public ServiceResult<CarDriverDtlModel> SetCarDriverDtlIns(CarDriverDtlModel objCarDriverDtlModel)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverDtlIns REQ] {JsonConvert.SerializeObject(objCarDriverDtlModel)}", bLogWrite);

            ServiceResult<CarDriverDtlModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CarDriverDtlModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objCarDriverDtlModel.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",       DBType.adBigInt,    objCarDriverDtlModel.DriverSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",        DBType.adVarChar,   objCarDriverDtlModel.DriverCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",        DBType.adVarWChar,  objCarDriverDtlModel.DriverName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEncPersonalNo",     DBType.adVarChar,   objCarDriverDtlModel.EncPersonalNo,      200,     ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strAuthName",          DBType.adVarWChar,  objCarDriverDtlModel.AuthName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCI",                DBType.adVarChar,   objCarDriverDtlModel.CI,                 128,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDI",                DBType.adVarChar,   objCarDriverDtlModel.DI,                 128,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInformationFlag",   DBType.adChar,      objCarDriverDtlModel.InformationFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgreementFlag",     DBType.adChar,      objCarDriverDtlModel.AgreementFlag,      1,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intDriverDtlSeqNo",    DBType.adBigInt,    DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_DTL_TX_INS");

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
                objCarDriverDtlModel.DriverDtlSeqNo = lo_objDas.GetParam("@po_intDriverDtlSeqNo").ToInt64();

                lo_objResult.data = objCarDriverDtlModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCarDriverDtlIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverDtlIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 회원사별 기사 추가정보(산재보험) 목록
        /// </summary>
        public ServiceResult<ResCarDriverDtlList> GetCarDriverDtlList(ReqCarDriverDtlList objCarDriverDtlList)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverDtlList REQ] {JsonConvert.SerializeObject(objCarDriverDtlList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResCarDriverDtlList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarDriverDtlList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDriverDtlSeqNo",     DBType.adBigInt,    objCarDriverDtlList.DriverDtlSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objCarDriverDtlList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",        DBType.adBigInt,    objCarDriverDtlList.DriverSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",         DBType.adVarChar,   objCarDriverDtlList.DriverCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",         DBType.adVarWChar,  objCarDriverDtlList.DriverName,         50,      ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objCarDriverDtlList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objCarDriverDtlList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objCarDriverDtlList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_DTL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarDriverDtlList
                {
                    list      = new List<CarDriverDtlModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarDriverDtlModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarDriverDtlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[GetCarDriverDtlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 산재보험 개인정보 알림톡 발송 등록
        /// </summary>
        /// <param name="objCarDriverKakaoModel"></param>
        /// <returns></returns>
        public ServiceResult<CarDriverKakaoModel> SetCarDriverKakaoIns(CarDriverKakaoModel objCarDriverKakaoModel)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverKakaoIns REQ] {JsonConvert.SerializeObject(objCarDriverKakaoModel)}", bLogWrite);

            ServiceResult<CarDriverKakaoModel> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CarDriverKakaoModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objCarDriverKakaoModel.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendType",      DBType.adTinyInt,   objCarDriverKakaoModel.SendType,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",   DBType.adBigInt,    objCarDriverKakaoModel.DriverSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",      DBType.adBigInt,    objCarDriverKakaoModel.RefSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",    DBType.adVarChar,   objCarDriverKakaoModel.RegAdminID,      50,      ParameterDirection.Input);
                                                           
                lo_objDas.AddParam("@po_intSeqNo",         DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_KAKAO_TX_INS");

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
                objCarDriverKakaoModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt64();

                lo_objResult.data = objCarDriverKakaoModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCarDriverKakaoIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverKakaoIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 기사정보 수정
        /// </summary>
        /// <param name="objReqCarDriverUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCarDriverInfoUpd(ReqCarDriverUpd objReqCarDriverUpd)
        {
            SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverInfoUpd REQ] {JsonConvert.SerializeObject(objReqCarDriverUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDriverSeqNo",   DBType.adBigInt,    objReqCarDriverUpd.DriverSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",    DBType.adVarWChar,  objReqCarDriverUpd.DriverName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",    DBType.adVarChar,   objReqCarDriverUpd.UpdAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_DRIVER_INFO_TX_UPD");

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
                                     , 9101, "System error(SetCarDriverInfoUpd) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarDispatchDasServices", "I", $"[SetCarDriverInfoUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}