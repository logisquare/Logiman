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
    public class ItemDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 항목 그룹 목록
        /// </summary>
        /// <param name="objReqItemGroupList"></param>
        /// <returns></returns>
        public ServiceResult<ResItemGroupList> GetItemGroupList(ReqItemGroupList objReqItemGroupList)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemGroupList REQ] {JsonConvert.SerializeObject(objReqItemGroupList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResItemGroupList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResItemGroupList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",      DBType.adInteger,  objReqItemGroupList.SeqNo,      0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupCode",  DBType.adChar,     objReqItemGroupList.GroupCode,  2,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupName",  DBType.adVarWChar, objReqItemGroupList.GroupName,  50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterFlag", DBType.adChar,     objReqItemGroupList.CenterFlag, 1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminFlag",  DBType.adChar,     objReqItemGroupList.AdminFlag,  1,  ParameterDirection.Input);
                                                        
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,  objReqItemGroupList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,  objReqItemGroupList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,  DBNull.Value,                   0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_GROUP_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResItemGroupList
                {
                    list      = new List<ItemGroupModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ItemGroupModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetItemGroupList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemGroupList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 항목 그룹 등록
        /// </summary>
        /// <param name="objItemGroupModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetItemGroupIns(ItemGroupModel objItemGroupModel)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemGroupIns REQ] {JsonConvert.SerializeObject(objItemGroupModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strGroupCode",  DBType.adChar,     objItemGroupModel.GroupCode,  2,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupName",  DBType.adVarWChar, objItemGroupModel.GroupName,  50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterFlag", DBType.adChar,     objItemGroupModel.CenterFlag, 1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminFlag",  DBType.adChar,     objItemGroupModel.AdminFlag,  1,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",      DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_GROUP_TX_INS");


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
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemGroupIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 항목 목록
        /// </summary>
        /// <param name="objReqItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResItemList> GetItemList(ReqItemList objReqItemList)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemList REQ] {JsonConvert.SerializeObject(objReqItemList)}", bLogWrite);

            string                     lo_strJson   = string.Empty;
            ServiceResult<ResItemList> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",         DBType.adInteger,   objReqItemList.SeqNo,        0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupCode",     DBType.adChar,      objReqItemList.GroupCode,    2,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupName",     DBType.adVarWChar,  objReqItemList.GroupName,    50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",      DBType.adChar,      objReqItemList.ItemCode,     3,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemFullCode",  DBType.adChar,      objReqItemList.ItemFullCode, 5,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strItemName",      DBType.adVarWChar,  objReqItemList.ItemName,     50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",      DBType.adInteger,   objReqItemList.PageSize,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",        DBType.adInteger,   objReqItemList.PageNo,       0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,   DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResItemList
                {
                    list      = new List<ItemModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ItemModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 항목 등록
        /// </summary>
        /// <param name="objItemModel"></param>
        /// <returns></returns>
        public ServiceResult<ItemModel> SetItemIns(ItemModel objItemModel)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemIns REQ] {JsonConvert.SerializeObject(objItemModel)}", bLogWrite);

            ServiceResult<ItemModel> lo_objResult = null;
            IDasNetCom               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ItemModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strItemGroupCode",   DBType.adChar,      objItemModel.ItemGroupCode,  2,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",        DBType.adChar,      objItemModel.ItemCode,       3,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemName",        DBType.adVarWChar,  objItemModel.ItemName,       50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterCodes",     DBType.adVarChar,   objItemModel.CenterCodes,    4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar,   objItemModel.RegAdminID,     50,    ParameterDirection.Input);
                                                             
                lo_objDas.AddParam("@po_intSeqNo",           DBType.adInteger,    DBNull.Value,               0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strItemCode",        DBType.adInteger,    DBNull.Value,               0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,    DBNull.Value,               256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,    DBNull.Value,               0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,    DBNull.Value,               256,  ParameterDirection.Output);
                                                             
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,    DBNull.Value,               0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_TX_INS");


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
                objItemModel.ItemCode = lo_objDas.GetParam("@po_strItemCode");
                objItemModel.SeqNo    = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objItemModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 회원사별 항목 목록
        /// </summary>
        /// <param name="objReqItemCenterList"></param>
        /// <returns></returns>
        public ServiceResult<ResItemCenterList> GetItemCenterList(ReqItemCenterList objReqItemCenterList)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemCenterList REQ] {JsonConvert.SerializeObject(objReqItemCenterList)}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResItemCenterList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResItemCenterList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCenterCodes",   DBType.adVarChar,   objReqItemCenterList.CenterCodes,  4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupCode",     DBType.adChar,      objReqItemCenterList.GroupCode,    2,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGroupName",     DBType.adVarWChar,  objReqItemCenterList.GroupName,    50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",      DBType.adChar,      objReqItemCenterList.ItemCode,     3,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemFullCode",  DBType.adChar,      objReqItemCenterList.ItemFullCode, 5,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strItemName",      DBType.adVarWChar,  objReqItemCenterList.ItemName,     50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",      DBType.adInteger,   objReqItemCenterList.PageSize,     0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",        DBType.adInteger,   objReqItemCenterList.PageNo,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,   DBNull.Value,                      0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_CENTER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResItemCenterList
                {
                    list      = new List<ItemCenterModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ItemCenterModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetItemCenterList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemCenterList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 회원사별 항목 등록/수정
        /// </summary>
        /// <param name="objItemCenterModel"></param>
        /// <returns></returns>
        public ServiceResult<ItemCenterModel> SetItemCenterIns(ItemCenterModel objItemCenterModel)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemCenterIns REQ] {JsonConvert.SerializeObject(objItemCenterModel)}", bLogWrite);

            ServiceResult<ItemCenterModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ItemCenterModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,    objItemCenterModel.CenterCode,   2,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemFullCode",    DBType.adChar,       objItemCenterModel.ItemFullCode, 5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",         DBType.adChar,       objItemCenterModel.UseFlag,      1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar,    objItemCenterModel.RegAdminID,   50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",           DBType.adInteger,    DBNull.Value,                    0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,    DBNull.Value,                    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,    DBNull.Value,                    0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,    DBNull.Value,                    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,    DBNull.Value,                    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_CENTER_TX_INS");


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
                objItemCenterModel.SeqNo    = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objItemCenterModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemCenterIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 항목 목록
        /// </summary>
        /// <param name="objReqItemAdminList"></param>
        /// <returns></returns>
        public ServiceResult<ResItemAdminList> GetItemAdminList(ReqItemAdminList objReqItemAdminList)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemAdminList REQ] {JsonConvert.SerializeObject(objReqItemAdminList)}", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResItemAdminList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResItemAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strGroupCode",     DBType.adChar,      objReqItemAdminList.GroupCode,    2,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemFullCode",  DBType.adChar,      objReqItemAdminList.ItemFullCode, 5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,   objReqItemAdminList.AdminID,      50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",      DBType.adInteger,   objReqItemAdminList.PageSize,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",        DBType.adInteger,   objReqItemAdminList.PageNo,       0,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,   DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_ADMIN_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResItemAdminList
                {
                    list      = new List<ItemAdminModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ItemAdminModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetItemAdminList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemAdminList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 사용자 항목 목록(JSON)
        /// </summary>
        /// <param name="objReqItemAdminList"></param>
        /// <returns></returns>
        public ServiceResult<ResItemAdminList> GetItemAdminListJson()
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemAdminListJson REQ]", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResItemAdminList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResItemAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.SetQuery("dbo.UP_ITEM_ADMIN_DR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResItemAdminList
                {
                    list = new List<ItemAdminModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ItemAdminModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetItemAdminList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[GetItemAdminListJson RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리자 항목 등록
        /// </summary>
        /// <param name="ItemAdminModel"></param>
        /// <returns></returns>
        public ServiceResult<ItemAdminModel> SetItemAdminIns(ItemAdminModel objItemAdminModel)
        {
            SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemAdminIns REQ] {JsonConvert.SerializeObject(objItemAdminModel)}", bLogWrite);

            ServiceResult<ItemAdminModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ItemAdminModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,  objItemAdminModel.AdminID,       50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemFullCode",   DBType.adChar,     objItemAdminModel.ItemFullCode,  5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBookmarkFlag",   DBType.adChar,     objItemAdminModel.BookmarkFlag,  1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAdminSort",      DBType.adInteger,  objItemAdminModel.AdminSort,     0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,  objItemAdminModel.RegAdminID,    50,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_intSeqNo",          DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ITEM_ADMIN_TX_INS");


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
                objItemAdminModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objItemAdminModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ItemDasServices", "I", $"[SetItemAdminIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}