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
    public class TaxDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 텍스빌 전표 목록
        /// </summary>
        /// <param name="objReqTaxBillList"></param>
        /// <returns></returns>
        public ServiceResult<ResTaxBillList> GetTaxBillList(int intCenterCode, ReqTaxBillList objReqTaxBillList)
        {
            SiteGlobal.WriteInformation("TaxDasServices", "I", $"[GetTaxBillList REQ] {JsonConvert.SerializeObject(objReqTaxBillList)}", bLogWrite);

            string                        lo_strJson   = string.Empty;
            ServiceResult<ResTaxBillList> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTaxBillList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();
                
                lo_objDas.Open(SiteGlobal.HOST_DAS_TAX);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strISSU_SEQNO",        DBType.adVarChar,   objReqTaxBillList.ISSU_SEQNO,        24,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strISSU_ID",           DBType.adVarChar,   objReqTaxBillList.ISSU_ID,           24,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFROM_YMD",          DBType.adVarChar,   objReqTaxBillList.FROM_YMD,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTO_YMD",            DBType.adVarChar,   objReqTaxBillList.TO_YMD,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTAX_TYPES",         DBType.adVarChar,   objReqTaxBillList.TAX_TYPES,         100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSTAT_CODE",         DBType.adVarChar,   objReqTaxBillList.STAT_CODE,         2,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strREQ_STAT_CODE",     DBType.adVarChar,   objReqTaxBillList.REQ_STAT_CODE,     2,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CORP_NM",      DBType.adVarChar,   objReqTaxBillList.SELR_CORP_NM,      30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CORP_NO",      DBType.adVarChar,   objReqTaxBillList.SELR_CORP_NO,      13,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CHRG_NM",      DBType.adVarChar,   objReqTaxBillList.SELR_CHRG_NM,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSELR_CHRG_EMAIL",   DBType.adVarChar,   objReqTaxBillList.SELR_CHRG_EMAIL,   70,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CORP_NM",      DBType.adVarChar,   objReqTaxBillList.BUYR_CORP_NM,      70,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CORP_NO",      DBType.adVarChar,   objReqTaxBillList.BUYR_CORP_NO,      13,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CHRG_NM1",     DBType.adVarChar,   objReqTaxBillList.BUYR_CHRG_NM1,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CHRG_EMAIL1",  DBType.adVarChar,   objReqTaxBillList.BUYR_CHRG_EMAIL1,  70,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPAGE_SIZE",         DBType.adInteger,   objReqTaxBillList.PAGE_SIZE,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPAGE_NO",           DBType.adInteger,   objReqTaxBillList.PAGE_NO,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRECORD_CNT",        DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_LOGIMAN_ITIS_ISSU_MSTR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTaxBillList
                {
                    list = new List<TaxBillModel>(),
                    RECORD_CNT = lo_objDas.GetParam("@po_intRECORD_CNT").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("CenterCode", typeof(int));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["CenterCode"] = intCenterCode;
                    }
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TaxBillModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetTaxBillList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TaxDasServices", "I", $"[GetTaxBillList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 텍스빌 전표 상세 목록
        /// </summary>
        /// <param name="objReqTaxBillItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResTaxBillItemList> GetTaxBillItemList(string strISSU_SEQNO)
        {
            SiteGlobal.WriteInformation("TaxDasServices", "I", $"[GetTaxBillItemList REQ] {strISSU_SEQNO}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResTaxBillItemList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTaxBillItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();
                
                lo_objDas.Open(SiteGlobal.HOST_DAS_TAX);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strISSU_SEQNO",     DBType.adVarChar,   strISSU_SEQNO,    24,      ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_LOGIMAN_ITIS_ISSU_DETAIL_DR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTaxBillItemList
                {
                    list = new List<TaxBillItemModel>(),
                    RECORD_CNT = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TaxBillItemModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetTaxBillItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TaxDasServices", "I", $"[GetTaxBillItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 텍스빌 전표 발행
        /// </summary>
        /// <param name="objReqTaxBillIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetTaxBillIns(ReqTaxBillIns objReqTaxBillIns)
        {
            SiteGlobal.WriteInformation("TaxDasServices", "I", $"[SetTaxBillIns REQ] {JsonConvert.SerializeObject(objReqTaxBillIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_TAX);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strISSU_SEQNO",         DBType.adVarChar,     objReqTaxBillIns.ISSU_SEQNO,           24,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTAX_CHG_FLAG",       DBType.adChar,        objReqTaxBillIns.TAX_CHG_FLAG,         1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intITEM_AMT",           DBType.adCurrency,    objReqTaxBillIns.ITEM_AMT,             0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intITEM_TAX",           DBType.adCurrency,    objReqTaxBillIns.ITEM_TAX,             0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUY_DATE",           DBType.adChar,        objReqTaxBillIns.BUY_DATE,             8,      ParameterDirection.Input);
                                                                                                                                               
                lo_objDas.AddParam("@pi_strTAX_TYPE",           DBType.adChar,        objReqTaxBillIns.TAX_TYPE,             4,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPOPS_CODE",          DBType.adChar,        objReqTaxBillIns.POPS_CODE,            2,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMODY_CODE",          DBType.adChar,        objReqTaxBillIns.MODY_CODE,            2,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNOTE1",              DBType.adVarChar,     objReqTaxBillIns.NOTE1,                150,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNOTE2",              DBType.adVarChar,     objReqTaxBillIns.NOTE2,                150,    ParameterDirection.Input);
                                                                                      
                lo_objDas.AddParam("@pi_strNOTE3",              DBType.adVarChar,     objReqTaxBillIns.NOTE3,                150,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CORP_NO",       DBType.adChar,        objReqTaxBillIns.SELR_CORP_NO,         13,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CORP_NM",       DBType.adVarChar,     objReqTaxBillIns.SELR_CORP_NM,         70,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CEO",           DBType.adVarChar,     objReqTaxBillIns.SELR_CEO,             30,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_ADDR",          DBType.adVarChar,     objReqTaxBillIns.SELR_ADDR,            150,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSELR_TEL",           DBType.adVarChar,     objReqTaxBillIns.SELR_TEL,             20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_BUSS_CONS",     DBType.adVarChar,     objReqTaxBillIns.SELR_BUSS_CONS,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_BUSS_TYPE",     DBType.adVarChar,     objReqTaxBillIns.SELR_BUSS_TYPE,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CHRG_NM",       DBType.adVarChar,     objReqTaxBillIns.SELR_CHRG_NM,         30,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSELR_CHRG_EMAIL",    DBType.adVarChar,     objReqTaxBillIns.SELR_CHRG_EMAIL,      40,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSELR_CHRG_MOBL",     DBType.adVarChar,     objReqTaxBillIns.SELR_CHRG_MOBL,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBANK_NOTE1",         DBType.adVarChar,     objReqTaxBillIns.BANK_NOTE1,           100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CORP_NO",       DBType.adChar,        objReqTaxBillIns.BUYR_CORP_NO,         13,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CORP_NM",       DBType.adVarChar,     objReqTaxBillIns.BUYR_CORP_NM,         70,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CEO",           DBType.adVarChar,     objReqTaxBillIns.BUYR_CEO,             30,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBUYR_ADDR",          DBType.adVarChar,     objReqTaxBillIns.BUYR_ADDR,            150,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_TEL",           DBType.adVarChar,     objReqTaxBillIns.BUYR_TEL,             20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_BUSS_CONS",     DBType.adVarChar,     objReqTaxBillIns.BUYR_BUSS_CONS,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_BUSS_TYPE",     DBType.adVarChar,     objReqTaxBillIns.BUYR_BUSS_TYPE,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CHRG_NM",       DBType.adVarChar,     objReqTaxBillIns.BUYR_CHRG_NM,         30,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBUYR_CHRG_EMAIL",    DBType.adVarChar,     objReqTaxBillIns.BUYR_CHRG_EMAIL,      40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBUYR_CHRG_MOBL",     DBType.adVarChar,     objReqTaxBillIns.BUYR_CHRG_MOBL,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_CORP_NO",       DBType.adChar,        objReqTaxBillIns.BROK_CORP_NO,         13,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_CORP_NM",       DBType.adVarChar,     objReqTaxBillIns.BROK_CORP_NM,         70,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_CEO",           DBType.adVarChar,     objReqTaxBillIns.BROK_CEO,             30,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBROK_ADDR",          DBType.adVarChar,     objReqTaxBillIns.BROK_ADDR,            150,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_TEL",           DBType.adVarChar,     objReqTaxBillIns.BROK_TEL,             20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_BUSS_CONS",     DBType.adVarChar,     objReqTaxBillIns.BROK_BUSS_CONS,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_BUSS_TYPE",     DBType.adVarChar,     objReqTaxBillIns.BROK_BUSS_TYPE,       40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_CHRG_NM",       DBType.adVarChar,     objReqTaxBillIns.BROK_CHRG_NM,         30,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBROK_CHRG_EMAIL",    DBType.adVarChar,     objReqTaxBillIns.BROK_CHRG_EMAIL,      40,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBROK_CHRG_MOBL",     DBType.adVarChar,     objReqTaxBillIns.BROK_CHRG_MOBL,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBILL_TYPE",          DBType.adChar,        objReqTaxBillIns.BILL_TYPE,            1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBFO_ISSU_SEQNO",     DBType.adVarChar,     objReqTaxBillIns.BFO_ISSU_SEQNO,       24,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE1",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE1,        8,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_NM1",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM1,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT1",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT1,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE1",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE1,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT1",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT1,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX1",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX1,        0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP1",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP1,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE2",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE2,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM2",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM2,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT2",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT2,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE2",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE2,       18,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT2",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT2,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX2",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX2,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP2",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP2,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE3",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE3,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM3",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM3,         100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT3",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT3,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE3",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE3,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT3",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT3,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX3",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX3,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP3",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP3,       100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_BUY_DATE4",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE4,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM4",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM4,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT4",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT4,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE4",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE4,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT4",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT4,        0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX4",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX4,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP4",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP4,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE5",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE5,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM5",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM5,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT5",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT5,       12,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE5",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE5,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT5",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT5,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX5",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX5,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP5",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP5,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE6",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE6,        8,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_NM6",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM6,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT6",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT6,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE6",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE6,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT6",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT6,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX6",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX6,        0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP6",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP6,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE7",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE7,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM7",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM7,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT7",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT7,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE7",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE7,       18,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT7",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT7,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX7",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX7,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP7",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP7,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE8",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE8,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM8",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM8,         100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT8",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT8,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE8",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE8,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT8",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT8,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX8",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX8,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP8",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP8,       100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_BUY_DATE9",      DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE9,        8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM9",       DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM9,         100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT9",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT9,       12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE9",     DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE9,       18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT9",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT9,        0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX9",      DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX9,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP9",     DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP9,       100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE10",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE10,       8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM10",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM10,        100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT10",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT10,      12,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE10",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE10,      18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT10",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT10,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX10",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX10,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP10",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP10,      100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE11",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE11,       8,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_NM11",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM11,        100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT11",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT11,      12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE11",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE11,      18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT11",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT11,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX11",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX11,       0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP11",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP11,      100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE12",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE12,       8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM12",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM12,        100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT12",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT12,      12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE12",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE12,      18,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT12",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT12,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX12",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX12,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP12",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP12,      100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE13",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE13,       8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM13",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM13,        100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT13",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT13,      12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE13",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE13,      18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT13",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT13,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX13",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX13,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP13",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP13,      100,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_BUY_DATE14",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE14,       8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM14",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM14,        100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT14",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT14,      12,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE14",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE14,      18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT14",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT14,       0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX14",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX14,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP14",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP14,      100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_BUY_DATE15",     DBType.adVarChar,     objReqTaxBillIns.DTL_BUY_DATE15,       8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_NM15",      DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_NM15,        100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_QUNT15",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_QUNT15,      12,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDTL_UNIT_PRCE15",    DBType.adVarChar,     objReqTaxBillIns.DTL_UNIT_PRCE15,      18,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_AMT15",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_AMT15,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDTL_ITEM_TAX15",     DBType.adCurrency,    objReqTaxBillIns.DTL_ITEM_TAX15,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDTL_ITEM_DESP15",    DBType.adVarChar,     objReqTaxBillIns.DTL_ITEM_DESP15,      100,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strERR_MSG",            DBType.adVarChar,     DBNull.Value,                          256,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRET_VAL",            DBType.adInteger,     DBNull.Value,                          0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDB_ERR_MSG",         DBType.adVarChar,     DBNull.Value,                          256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDB_RET_VAL",         DBType.adInteger,     DBNull.Value,                          0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_LOGIMAN_TAXBILL_TX_INS");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRET_VAL").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRET_VAL").ToInt(), lo_objDas.GetParam("@po_strERR_MSG")
                                         , lo_objDas.GetParam("@po_intDB_RET_VAL").ToInt(), lo_objDas.GetParam("@po_strDB_ERR_MSG"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetTaxBillIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TaxDasServices", "I", $"[SetTaxBillIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 텍스빌 계산서 발행 취소
        /// </summary>
        /// <param name="objReqTaxBillCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetTaxBillCnl(string strISSU_SEQNO)
        {
            SiteGlobal.WriteInformation("TaxDasServices", "I", $"[SetTaxBillCnl REQ] {strISSU_SEQNO}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();
                
                lo_objDas.Open(SiteGlobal.HOST_DAS_TAX);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                                
                lo_objDas.AddParam("@pi_strISSU_SEQNO",   DBType.adVarChar,   strISSU_SEQNO,   24,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strERR_MSG",      DBType.adVarChar,   DBNull.Value,    256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRET_VAL",      DBType.adInteger,   DBNull.Value,    0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDB_ERR_MSG",   DBType.adVarChar,   DBNull.Value,    256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDB_RET_VAL",   DBType.adInteger,   DBNull.Value,    0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_LOGIMAN_TAXBILL_TX_CNL");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRET_VAL").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRET_VAL").ToInt(), lo_objDas.GetParam("@po_strERR_MSG")
                                         , lo_objDas.GetParam("@po_intDB_RET_VAL").ToInt(), lo_objDas.GetParam("@po_strDB_ERR_MSG"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetTaxBillCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TaxDasServices", "I", $"[SetTaxBillCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

    }
}