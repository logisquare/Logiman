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
    public class AppGpsDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// GPS 정보 조회
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResAppGpsList> GetAppGpsList(ReqAppGpsList objReqAppGpsList)
        {
            SiteGlobal.WriteInformation("AppGpsDasServices", "I", $"[GetAppGpsList REQ] {JsonConvert.SerializeObject(objReqAppGpsList)}", bLogWrite);

            string                       lo_strJson   = string.Empty;
            ServiceResult<ResAppGpsList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppGpsList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //lo_objDas.Open(SiteGlobal.HOST_DAS_TMS_GW);     // [logimanDebug]
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMobileNo",         DBType.adVarChar,    objReqAppGpsList.MobileNo,          20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",          DBType.adVarChar,    objReqAppGpsList.DateFrom,          8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",            DBType.adVarChar,    objReqAppGpsList.DateTo,            8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMaxLinearMeter",   DBType.adInteger,    objReqAppGpsList.MaxLinearMeter,    0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMaxMinutes",       DBType.adInteger,    objReqAppGpsList.MaxMinutes,        0,     ParameterDirection.Input);
                                                                                                                              
                lo_objDas.AddParam("@po_intTotalDistance",    DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strTotalElapsedTime", DBType.adVarWChar,   DBNull.Value,                       100,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_GPS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppGpsList
                {
                    list             = new List<AppGpsGridModel>(),
                    RecordCnt        = lo_objDas.RecordCount,
                    TotalDistance    = lo_objDas.GetParam("@po_intTotalDistance").ToInt(),
                    TotalElapsedTime = lo_objDas.GetParam("@po_strTotalElapsedTime")
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppGpsGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAppGpsList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppGpsDasServices", "I", $"[GetGPSDayAllCarsList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}