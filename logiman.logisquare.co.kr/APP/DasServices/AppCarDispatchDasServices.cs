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
    public class AppCarDispatchDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 차량조회 리스트
        /// </summary>
        public ServiceResult<ResAppCarDispatchList> GetCarDispatchList(ReqAppCarDispatchList objCarDispatchList)
        {
            SiteGlobal.WriteInformation("AppCarDispatchDasServices", "I", $"[GetCarDispatchList REQ] {JsonConvert.SerializeObject(objCarDispatchList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResAppCarDispatchList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
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

                lo_objDas.SetQuery("dbo.UP_APP_CAR_DISPATCH_REF_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppCarDispatchList
                {
                    list      = new List<AppCarDispatchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppCarDispatchListViewModel>>(lo_strJson);
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

                SiteGlobal.WriteInformation("AppCarDispatchDasServices", "I", $"[GetCarDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}