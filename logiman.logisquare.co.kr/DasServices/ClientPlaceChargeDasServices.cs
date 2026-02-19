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
    public class ClientPlaceChargeDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 상하차지 리스트
        /// </summary>
        public ServiceResult<ResClientPlaceChargeList> GetClientPlaceChargeList(ReqClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceChargeList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResClientPlaceChargeList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",            DBType.adBigInt,      objClientPlaceChargeList.SeqNo,             0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",       DBType.adBigInt,      objClientPlaceChargeList.PlaceSeqNo,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,     objClientPlaceChargeList.CenterCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",       DBType.adBigInt,      objClientPlaceChargeList.ClientCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,        objClientPlaceChargeList.UseFlag,           1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeName",       DBType.adVarWChar,    objClientPlaceChargeList.ChargeName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",      DBType.adVarChar,     objClientPlaceChargeList.ChargeTelNo,       20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",       DBType.adVarChar,     objClientPlaceChargeList.ChargeCell,        20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchType",       DBType.adVarChar,     objClientPlaceChargeList.SearchType,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",        DBType.adVarWChar,    objClientPlaceChargeList.PlaceName,         100, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeUseFlag",    DBType.adChar,        objClientPlaceChargeList.ChargeUseFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,     objClientPlaceChargeList.GradeCode,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,     objClientPlaceChargeList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,     objClientPlaceChargeList.AccessCorpNo,      512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,     objClientPlaceChargeList.PageSize,          0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,     objClientPlaceChargeList.PageNo,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,     DBNull.Value,                               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_CHARGE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceChargeList
                {
                    list      = new List<ClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceChargeListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientPlaceChargeList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceChargeList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResClientPlaceChargeList> GetClientPlaceList(ReqClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResClientPlaceChargeList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",         DBType.adBigInt,    objClientPlaceChargeList.PlaceSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objClientPlaceChargeList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objClientPlaceChargeList.ChargeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objClientPlaceChargeList.ChargeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objClientPlaceChargeList.UseFlag, 1, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPlaceName",          DBType.adVarWChar,  objClientPlaceChargeList.PlaceName, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",          DBType.adVarWChar,  objClientPlaceChargeList.ChargeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFullAddr",           DBType.adVarWChar,  objClientPlaceChargeList.PlaceName, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,   objClientPlaceChargeList.GradeCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objClientPlaceChargeList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,   objClientPlaceChargeList.AccessCorpNo, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objClientPlaceChargeList.PageSize, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objClientPlaceChargeList.PageNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceChargeList
                {
                    list = new List<ClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceChargeListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientPlaceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ClientPlaceChargeViewModel> InsClientPlaceCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[InsClientPlaceCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<ClientPlaceChargeViewModel> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ClientPlaceChargeViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,      objInsClientPlaceCharge.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,       objInsClientPlaceCharge.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",          DBType.adVarWChar,     objInsClientPlaceCharge.PlaceName, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlacePost",          DBType.adVarChar,      objInsClientPlaceCharge.PlacePost, 6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",          DBType.adVarWChar,     objInsClientPlaceCharge.PlaceAddr, 100, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPlaceAddrDtl",       DBType.adVarWChar,     objInsClientPlaceCharge.PlaceAddrDtl, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSido",               DBType.adVarWChar,     objInsClientPlaceCharge.Sido, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGugun",              DBType.adVarWChar,     objInsClientPlaceCharge.Gugun, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDong",               DBType.adVarWChar,     objInsClientPlaceCharge.Dong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFullAddr",           DBType.adVarWChar,     objInsClientPlaceCharge.FullAddr, 150, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeName",         DBType.adVarWChar,     objInsClientPlaceCharge.ChargeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",        DBType.adVarChar,      objInsClientPlaceCharge.ChargeTelNo, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelExtNo",     DBType.adVarChar,      objInsClientPlaceCharge.ChargeTelExtNo, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",         DBType.adVarChar,      objInsClientPlaceCharge.ChargeCell, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeFaxNo",        DBType.adVarChar,      objInsClientPlaceCharge.ChargeFaxNo, 20, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeEmail",        DBType.adVarChar,      objInsClientPlaceCharge.ChargeEmail, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",     DBType.adVarWChar,     objInsClientPlaceCharge.ChargePosition, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",   DBType.adVarWChar,     objInsClientPlaceCharge.ChargeDepartment, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeNote",         DBType.adVarWChar,     objInsClientPlaceCharge.ChargeNote, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocalCode",          DBType.adVarChar,      objInsClientPlaceCharge.LocalCode, 20, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strLocalName",          DBType.adVarWChar,     objInsClientPlaceCharge.LocalName, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark1",       DBType.adVarWChar,     objInsClientPlaceCharge.PlaceRemark1, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark2",       DBType.adVarWChar,     objInsClientPlaceCharge.PlaceRemark2, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark3",       DBType.adVarWChar,     objInsClientPlaceCharge.PlaceRemark3, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark4",       DBType.adVarWChar,     objInsClientPlaceCharge.PlaceRemark4, 500, ParameterDirection.Input); ;

                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,      objInsClientPlaceCharge.AdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intPlaceSeqNo",         DBType.adBigInt,       DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,      DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,      DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,      DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,      DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_TX_INS");

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
                objInsClientPlaceCharge.PlaceSeqNo = lo_objDas.GetParam("@po_intPlaceSeqNo").ToInt();

                lo_objResult.data = objInsClientPlaceCharge;
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

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[InsClientPlaceCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[InsCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",         DBType.adBigInt,    objInsClientPlaceCharge.PlaceSeqNo,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",         DBType.adVarWChar,  objInsClientPlaceCharge.ChargeName,     50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",        DBType.adVarChar,   objInsClientPlaceCharge.ChargeTelNo,    20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelExtNo",     DBType.adVarChar,   objInsClientPlaceCharge.ChargeTelExtNo, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",         DBType.adVarChar,   objInsClientPlaceCharge.ChargeCell,     20, ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strChargeFaxNo",        DBType.adVarChar,   objInsClientPlaceCharge.ChargeFaxNo,    20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeEmail",        DBType.adVarChar,   objInsClientPlaceCharge.ChargeEmail,    100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",     DBType.adVarWChar,  objInsClientPlaceCharge.ChargePosition, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",   DBType.adVarWChar,  objInsClientPlaceCharge.ChargeDepartment, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeNote",         DBType.adVarWChar,  objInsClientPlaceCharge.ChargeNote,     500, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,   objInsClientPlaceCharge.AdminID,        50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",              DBType.adBigInt,    DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_CHARGE_TX_INS");

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

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[InsCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[DelCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adBigInt,    objInsClientPlaceCharge.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",         DBType.adBigInt,    objInsClientPlaceCharge.PlaceSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos1",            DBType.adVarChar,   objInsClientPlaceCharge.SeqNos1,    4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos2",            DBType.adVarChar,   objInsClientPlaceCharge.SeqNos2,    4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos3",            DBType.adVarChar,   objInsClientPlaceCharge.SeqNos3,    4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSeqNos4",            DBType.adVarChar,   objInsClientPlaceCharge.SeqNos4,    4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos5",            DBType.adVarChar,   objInsClientPlaceCharge.SeqNos5,    4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",         DBType.adVarChar,   objInsClientPlaceCharge.AdminID,    50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCount",         DBType.adTinyInt,   DBNull.Value,                       0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intResultCount",        DBType.adTinyInt,   DBNull.Value,                       0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_CHARGE_SELECTED_TX_DEL");

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

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[DelCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[UpdCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",         DBType.adBigInt,        objInsClientPlaceCharge.PlaceSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,        objInsClientPlaceCharge.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlacePost",          DBType.adVarChar,       objInsClientPlaceCharge.PlacePost, 6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",          DBType.adVarWChar,      objInsClientPlaceCharge.PlaceAddr, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddrDtl",       DBType.adVarWChar,      objInsClientPlaceCharge.PlaceAddrDtl, 100, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSido",               DBType.adVarWChar,      objInsClientPlaceCharge.Sido, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGugun",              DBType.adVarWChar,      objInsClientPlaceCharge.Gugun, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDong",               DBType.adVarWChar,      objInsClientPlaceCharge.Dong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFullAddr",           DBType.adVarWChar,      objInsClientPlaceCharge.FullAddr, 150, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocalCode",          DBType.adVarChar,       objInsClientPlaceCharge.LocalCode, 20, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strLocalName",          DBType.adVarWChar,      objInsClientPlaceCharge.LocalName, 100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark1",       DBType.adVarWChar,      objInsClientPlaceCharge.PlaceRemark1, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark2",       DBType.adVarWChar,      objInsClientPlaceCharge.PlaceRemark2, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark3",       DBType.adVarWChar,      objInsClientPlaceCharge.PlaceRemark3, 500, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark4",       DBType.adVarWChar,      objInsClientPlaceCharge.PlaceRemark4, 500, ParameterDirection.Input); ;

                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,          objInsClientPlaceCharge.UseFlag,    1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",         DBType.adVarChar,       objInsClientPlaceCharge.AdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,       DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,       DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,       DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,       DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_TX_UPD");

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

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[UpdCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 상하차지 목록 검색(오더)
        /// </summary>
        /// <param name="objClientPlaceSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientPlaceSearchList> GetClientPlaceSearchList(ReqClientPlaceSearchList objClientPlaceSearchList)
        {
            SiteGlobal.WriteInformation("ClientPlaceDasServices", "I", $"[GetClientPlaceSearchList REQ] {JsonConvert.SerializeObject(objClientPlaceSearchList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResClientPlaceSearchList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,     objClientPlaceSearchList.CenterCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",        DBType.adVarWChar,    objClientPlaceSearchList.PlaceName,         100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,        objClientPlaceSearchList.UseFlag,           1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",       DBType.adVarWChar,    objClientPlaceSearchList.ChargeName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeUseFlag",    DBType.adChar,        objClientPlaceSearchList.ChargeUseFlag,     1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,     objClientPlaceSearchList.GradeCode,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,     objClientPlaceSearchList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,     objClientPlaceSearchList.AccessCorpNo,      512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,     objClientPlaceSearchList.PageSize,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,     objClientPlaceSearchList.PageNo,            0,   ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,     DBNull.Value,                               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceSearchList
                {
                    list      = new List<ClientPlaceSearchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceSearchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientPlaceSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }



        /// <summary>
        /// 상하차지 담당자 목록 검색
        /// </summary>
        /// <param name="objClientPlaceChargeSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientPlaceChargeSearchList> GetClientPlaceChargeSearchList(ReqClientPlaceChargeSearchList objClientPlaceChargeSearchList)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceChargeSearchList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeSearchList)}", bLogWrite);

            string                                        lo_strJson   = string.Empty;
            ServiceResult<ResClientPlaceChargeSearchList> lo_objResult = null;
            IDasNetCom                                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceChargeSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objClientPlaceChargeSearchList.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",       DBType.adBigInt,    objClientPlaceChargeSearchList.PlaceSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",        DBType.adVarWChar,  objClientPlaceChargeSearchList.PlaceName,         100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,      objClientPlaceChargeSearchList.UseFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",       DBType.adVarWChar,  objClientPlaceChargeSearchList.ChargeName,        50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeUseFlag",    DBType.adChar,      objClientPlaceChargeSearchList.ChargeUseFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,   objClientPlaceChargeSearchList.GradeCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,   objClientPlaceChargeSearchList.AccessCenterCode,  512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,   objClientPlaceChargeSearchList.AccessCorpNo,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,   objClientPlaceChargeSearchList.PageSize,          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,   objClientPlaceChargeSearchList.PageNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_CHARGE_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceChargeSearchList
                {
                    list      = new List<ClientPlaceChargeSearchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceChargeSearchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientPlaceChargeSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeChargeDasServices", "I", $"[GetClientPlaceChargeSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 상하차지 특이사항 조회
        /// </summary>
        /// <param name="objReqClientPlaceNote"></param>
        /// <returns></returns>
        public ServiceResult<ResClientPlaceNote> GetClientPlaceNote(ReqClientPlaceNote objReqClientPlaceNote)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceNote REQ] {JsonConvert.SerializeObject(objReqClientPlaceNote)}", bLogWrite);

            ServiceResult<ResClientPlaceNote> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceNote>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqClientPlaceNote.CenterCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",          DBType.adVarWChar,  objReqClientPlaceNote.PlaceName,    100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",          DBType.adVarWChar,  objReqClientPlaceNote.PlaceAddr,    100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddrDtl",       DBType.adVarWChar,  objReqClientPlaceNote.PlaceAddrDtl, 100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqClientPlaceNote.AdminID,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intPlaceSeqNo",         DBType.adBigInt,    DBNull.Value,                       0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceRemark1",       DBType.adVarWChar,  DBNull.Value,                       500,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceRemark2",       DBType.adVarWChar,  DBNull.Value,                       500,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceRemark3",       DBType.adVarWChar,  DBNull.Value,                       500,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceRemark4",       DBType.adVarWChar,  DBNull.Value,                       500,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_NOTE_NT_GET");

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
                lo_objResult.data = new ResClientPlaceNote
                {
                    PlaceSeqNo   = lo_objDas.GetParam("@po_intPlaceSeqNo"),
                    PlaceRemark1 = lo_objDas.GetParam("@po_strPlaceRemark1"),
                    PlaceRemark2 = lo_objDas.GetParam("@po_strPlaceRemark2"),
                    PlaceRemark3 = lo_objDas.GetParam("@po_strPlaceRemark3"),
                    PlaceRemark4 = lo_objDas.GetParam("@po_strPlaceRemark4")
                };

            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientPlaceNote)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[GetClientPlaceNote RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 상하차지 특이사항 수정
        /// </summary>
        /// <param name="objReqClientPlaceNoteUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientPlaceNoteUpd(ReqClientPlaceNoteUpd objReqClientPlaceNoteUpd)
        {
            SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[SetClientPlaceNoteUpd REQ] {JsonConvert.SerializeObject(objReqClientPlaceNoteUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqClientPlaceNoteUpd.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderType",      DBType.adTinyInt,   objReqClientPlaceNoteUpd.OrderType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",     DBType.adBigInt,    objReqClientPlaceNoteUpd.PlaceSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark1",   DBType.adVarWChar,  objReqClientPlaceNoteUpd.PlaceRemark1,   500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark2",   DBType.adVarWChar,  objReqClientPlaceNoteUpd.PlaceRemark2,   500,     ParameterDirection.Input);
                                                                                                                         
                lo_objDas.AddParam("@pi_strPlaceRemark3",   DBType.adVarWChar,  objReqClientPlaceNoteUpd.PlaceRemark3,   500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceRemark4",   DBType.adVarWChar,  objReqClientPlaceNoteUpd.PlaceRemark4,   500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqClientPlaceNoteUpd.AdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                                                                                                                        
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_PLACE_NOTE_TX_UPD");

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
                                     , 9101, "System error(SetClientPlaceNoteUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientPlaceChargeDasServices", "I", $"[SetClientPlaceNoteUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}