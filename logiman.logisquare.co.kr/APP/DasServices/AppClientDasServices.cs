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
    public class AppClientDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 고객사 목록
        /// </summary>
        /// <param name="objReqClientList"></param>
        /// <returns></returns>
        public ServiceResult<ResAppClientList> GetClientList(ReqAppClientList objReqClientList)
        {
            SiteGlobal.WriteInformation("AppClientDasServices", "I", $"[GetClientList REQ] {JsonConvert.SerializeObject(objReqClientList)}", bLogWrite);
            
            string                       lo_strJson   = string.Empty;
            ServiceResult<ResAppClientList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,   objReqClientList.ClientCode,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,  objReqClientList.CenterCode,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",          DBType.adVarWChar, objReqClientList.ClientName,          50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientType",          DBType.adVarChar,  objReqClientList.ClientType,          5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCeoName",       DBType.adVarWChar, objReqClientList.ClientCeoName,       50,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientCorpNo",        DBType.adVarChar,  objReqClientList.ClientCorpNo,        20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleLimitAmtFlag",    DBType.adChar,     objReqClientList.SaleLimitAmtFlag,    1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRevenueLimitPerFlag", DBType.adChar,     objReqClientList.RevenueLimitPerFlag, 1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",             DBType.adChar,     objReqClientList.UseFlag,             1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,  objReqClientList.AccessCenterCode,    512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,  objReqClientList.PageSize,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,  objReqClientList.PageNo,              0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppClientList
                {
                    list      = new List<AppClientModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("ClientAcctNo", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["ClientAcctNo"] = CommonUtils.Utils.GetDecrypt(row["ClientEncAcctNo"].ToString());
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppClientModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppClientDasServices", "I", $"[GetClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}