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
    public class AppMainDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 차량조회 리스트
        /// </summary>
        public ServiceResult<ResMainList> GetMainList(ReqMainList objqMainList)
        {
            SiteGlobal.WriteInformation("AppMainDasServices", "I", $"[GetMainList REQ] {JsonConvert.SerializeObject(objqMainList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResMainList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResMainList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",                    DBType.adVarChar,   objqMainList.AdminID,           50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",           DBType.adVarChar,   objqMainList.AccessCenterCode,  512,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intAcceptOrderCnt",             DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDispatchOrderCnt",           DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
                lo_objDas.SetQuery("dbo.UP_APP_ADMIN_MAIN_SUMMARY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResMainList
                {
                    list = new List<ResMainListViewModel>(),
                    AcceptOrderCnt      = lo_objDas.GetParam("@po_intAcceptOrderCnt").ToInt(),
                    DispatchOrderCnt    = lo_objDas.GetParam("@po_intDispatchOrderCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResMainListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetMainList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AppMainDasServices", "I", $"[GetMainList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}