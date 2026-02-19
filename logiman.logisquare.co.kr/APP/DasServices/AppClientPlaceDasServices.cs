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
    public class AppClientPlaceDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 상하차지 리스트
        /// </summary>
        public ServiceResult<ResAppClientPlaceChargeList> GetClientPlaceChargeList(ReqAppClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("AppClientPlaceDasServices", "I", $"[GetClientPlaceChargeList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResAppClientPlaceChargeList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",            DBType.adBigInt,      objClientPlaceChargeList.SeqNo,             0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",       DBType.adBigInt,      objClientPlaceChargeList.PlaceSeqNo,        0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,     objClientPlaceChargeList.CenterCode,        0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,        objClientPlaceChargeList.UseFlag,           1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",       DBType.adVarWChar,    objClientPlaceChargeList.ChargeName,        50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeTelNo",      DBType.adVarChar,     objClientPlaceChargeList.ChargeTelNo,       20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",       DBType.adVarChar,     objClientPlaceChargeList.ChargeCell,        20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",        DBType.adVarWChar,    objClientPlaceChargeList.PlaceName,         100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeUseFlag",    DBType.adChar,        objClientPlaceChargeList.ChargeUseFlag,     1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",        DBType.adTinyInt,     objClientPlaceChargeList.GradeCode,         0,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,     objClientPlaceChargeList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,     objClientPlaceChargeList.AccessCorpNo,      512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,     objClientPlaceChargeList.PageSize,          0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,     objClientPlaceChargeList.PageNo,            0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,     DBNull.Value,                               0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_CLIENT_PLACE_CHARGE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppClientPlaceChargeList
                {
                    list = new List<AppClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppClientPlaceChargeListViewModel>>(lo_strJson);
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
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AppClientPlaceDasServices", "I", $"[GetClientPlaceChargeList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResAppClientPlaceChargeList> GetAppClientPlaceList(ReqAppClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("AppClientPlaceDasServices", "I", $"[GetAppClientPlaceList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResAppClientPlaceChargeList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",         DBType.adBigInt,    objClientPlaceChargeList.PlaceSeqNo,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objClientPlaceChargeList.CenterCode,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSearchType",         DBType.adTinyInt,   objClientPlaceChargeList.SearchType,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",          DBType.adVarWChar,  objClientPlaceChargeList.PlaceName,     100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objClientPlaceChargeList.UseFlag,       1, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,   objClientPlaceChargeList.GradeCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objClientPlaceChargeList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,   objClientPlaceChargeList.AccessCorpNo,      512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objClientPlaceChargeList.PageSize,          0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objClientPlaceChargeList.PageNo,            0, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                               0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_CLIENT_PLACE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppClientPlaceChargeList
                {
                    list = new List<AppClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppClientPlaceChargeListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAppClientPlaceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AppClientPlaceDasServices", "I", $"[GetAppClientPlaceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}