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
    public class ClientSaleLimitDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 거래처 매출 통계 목록
        /// </summary>
        /// <param name="objReqClientSaleLimitList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientSaleLimitList> GetClientSaleLimitList(ReqClientSaleLimitList objReqClientSaleLimitList)
        {
            SiteGlobal.WriteInformation("ClientSaleLimitDasServices", "I", $"[GetClientSaleLimitList REQ] {JsonConvert.SerializeObject(objReqClientSaleLimitList)}", bLogWrite);
            
            string                                lo_strJson   = string.Empty;
            ServiceResult<ResClientSaleLimitList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientSaleLimitList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",       DBType.adBigInt,   objReqClientSaleLimitList.ClientCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqClientSaleLimitList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",       DBType.adVarWChar, objReqClientSaleLimitList.ClientName,       50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",         DBType.adVarChar,  objReqClientSaleLimitList.DateFrom,         5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",           DBType.adVarChar,  objReqClientSaleLimitList.DateTo,           5,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqClientSaleLimitList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,  objReqClientSaleLimitList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,  objReqClientSaleLimitList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,  DBNull.Value,                               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_SALE_LIMIT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientSaleLimitList
                {
                    list      = new List<ClientSaleLimit>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientSaleLimit>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientSaleLimitList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientSaleLimitDasServices", "I", $"[GetClientSaleLimitList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 거래처 매출 통계 조회
        /// </summary>
        /// <param name="objClientSaleLimit"></param>
        /// <returns></returns>
        public ServiceResult<ResClientSaleLimit> GetClientSaleLimit(ReqClientSaleLimit objClientSaleLimit)
        {
            SiteGlobal.WriteInformation("ClientSaleLimitDasServices", "I", $"[GetClientSaleLimit REQ] {JsonConvert.SerializeObject(objClientSaleLimit)}", bLogWrite);

            ServiceResult<ResClientSaleLimit> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientSaleLimit>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strYMD",                    DBType.adVarChar, objClientSaleLimit.YMD,         8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger, objClientSaleLimit.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",             DBType.adBigInt,  objClientSaleLimit.ClientCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,  objClientSaleLimit.OrderNo,     0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intClientBusinessStatus",   DBType.adTinyInt, DBNull.Value,                   0,   ParameterDirection.Output);
                
                lo_objDas.AddParam("@po_strLimitCheckFlag",         DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLimitAvailFlag",         DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSaleLimitAmt",           DBType.adDouble,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intLimitAvailAmt",          DBType.adDouble,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRevenueLimitPer",        DBType.adDouble,  DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_intTotalSaleAmt",           DBType.adDouble,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTotalPurchaseAmt",       DBType.adDouble,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger, DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar, DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger, DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_SALE_LIMIT_NT_GET");


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
                lo_objResult.data = new ResClientSaleLimit
                {
                    ClientBusinessStatus = lo_objDas.GetParam("@po_intClientBusinessStatus").ToInt(),
                    LimitCheckFlag       = lo_objDas.GetParam("@po_strLimitCheckFlag"),
                    LimitAvailFlag       = lo_objDas.GetParam("@po_strLimitAvailFlag"),
                    SaleLimitAmt         = lo_objDas.GetParam("@po_intSaleLimitAmt").ToDouble(),
                    LimitAvailAmt        = lo_objDas.GetParam("@po_intLimitAvailAmt").ToDouble(),
                    RevenueLimitPer      = lo_objDas.GetParam("@po_intRevenueLimitPer").ToDouble(),
                    TotalSaleAmt         = lo_objDas.GetParam("@po_intTotalSaleAmt").ToDouble(),
                    TotalPurchaseAmt     = lo_objDas.GetParam("@po_intTotalPurchaseAmt").ToDouble()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientSaleLimit)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientSaleLimitDasServices", "I", $"[GetClientSaleLimit RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}