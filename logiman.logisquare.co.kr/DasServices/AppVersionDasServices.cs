using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;
using System;
using System.Data;

namespace CommonLibrary.DasServices
{
    public class AppVersionDasServices
    {
        private bool bLogWrite = true;

        ///----------------------------------------------------------------------
        /// <summary>
        /// 앱 버젼 체크
        /// </summary>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public ServiceResult<ResAppVersionChk> GetAppVersionChk(ReqAppVersionChk request)
        {
            ServiceResult<ResAppVersionChk> lo_objResult = null;
            IDasNetCom lo_objDas    = null;
            string lo_strJson = string.Empty;

            try
            {
                lo_objResult = new ServiceResult<ResAppVersionChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDeviceKind",     DBType.adTinyInt, request.DeviceKind, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAppKind",        DBType.adTinyInt, request.AppKind, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intVerSeqNo",       DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAppVersion",     DBType.adVarWChar, DBNull.Value, 20, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAppVersionDesc", DBType.adVarWChar, DBNull.Value, 512, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDownloadForce",  DBType.adChar, DBNull.Value, 1, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strServiceStopFlag",DBType.adChar, DBNull.Value, 1, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNoticeTitle",    DBType.adVarWChar, DBNull.Value, 80, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNoticeMessage",  DBType.adVarWChar, DBNull.Value, 512, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegDate",        DBType.adVarChar, DBNull.Value, 19, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_VERSION_NT_CHK");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                         , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppVersionChk
                {
                    VerSeqNo        = Convert.ToInt32(lo_objDas.GetParam("@po_intVerSeqNo")),
                    AppVersion      = lo_objDas.GetParam("@po_strAppVersion"),
                    AppVersionDesc  = lo_objDas.GetParam("@po_strAppVersionDesc"),
                    DownloadForce   = lo_objDas.GetParam("@po_strDownloadForce"),
                    ServiceStopFlag = lo_objDas.GetParam("@po_strServiceStopFlag"),
                    NoticeTitle     = lo_objDas.GetParam("@po_strNoticeTitle"),
                    NoticeMessage   = lo_objDas.GetParam("@po_strNoticeMessage"),
                    RegDate         = lo_objDas.GetParam("@po_strRegDate")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin password)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AppVersionDasServices", "I", $"[GetItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}