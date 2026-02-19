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
    public class OrderDasServices
    {
        private bool bLogWrite = false;

        /// <summary>
        /// 오더 첨부파일 목록
        /// </summary>
        /// <param name="objReqOrderFileList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderFileList> GetOrderFileList(ReqOrderFileList objReqOrderFileList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderFileList REQ] {JsonConvert.SerializeObject(objReqOrderFileList)}", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResOrderFileList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderFileList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intFileSeqNo",          DBType.adInteger,   objReqOrderFileList.FileSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objReqOrderFileList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFileRegType",        DBType.adTinyInt,   objReqOrderFileList.FileRegType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderFileList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqOrderFileList.DelFlag,             1,       ParameterDirection.Input);
                                                                                                                  
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqOrderFileList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_FILE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderFileList
                {
                    list      = new List<OrderFileGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("EncFileSeqNo", typeof(string));
                    lo_objDas.objDT.Columns.Add("EncFileNameNew", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["EncFileSeqNo"] = CommonUtils.Utils.GetEncrypt(row["FileSeqNo"].ToString());
                        row["EncFileNameNew"] = CommonUtils.Utils.GetEncrypt(row["FileNameNew"].ToString());
                    }
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderFileGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderFileList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderFileList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 파일 등록
        /// </summary>
        /// <param name="objOrderFileModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderFileModel> SetOrderFileIns(OrderFileModel objOrderFileModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderFileIns REQ] {JsonConvert.SerializeObject(objOrderFileModel)}", bLogWrite);

            ServiceResult<OrderFileModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderFileModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",      DBType.adBigInt,    objOrderFileModel.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",   DBType.adInteger,   objOrderFileModel.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFileRegType",  DBType.adTinyInt,   objOrderFileModel.FileRegType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFileName",     DBType.adVarWChar,  objOrderFileModel.FileName,        100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFileNameNew",  DBType.adVarChar,   objOrderFileModel.FileNameNew,     100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFileDir",      DBType.adVarWChar,  objOrderFileModel.FileDir,         100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",   DBType.adVarChar,   objOrderFileModel.RegAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intFileSeqNo",    DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strFullUrl",      DBType.adVarWChar,  DBNull.Value,                      512,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_FILE_TX_INS");

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
                objOrderFileModel.FullUrl = lo_objDas.GetParam("@po_strFullUrl");
                lo_objResult.data         = objOrderFileModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderFileIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderFileIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 파일 삭제
        /// </summary>
        /// <param name="objOrderFileModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderFileDel(long intOrderNo, int intCenterCode, long intFileSeqNo, string strAdminID, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderFileDel REQ] {intOrderNo} | {intCenterCode} | {intFileSeqNo} | {strAdminID} | {strAccessCenterCode}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   intCenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFileSeqNo",          DBType.adBigInt,    intFileSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",         DBType.adVarChar,   strAdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   strAccessCenterCode,  512,     ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_FILE_TX_DEL");

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
                                     , 9101, "System error(SetOrderFileDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderFileDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

    
        /// <summary>
        /// 오더 등록
        /// </summary>
        /// <param name="objOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderModel> SetOrderIns(OrderModel objOrderModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderIns REQ] {JsonConvert.SerializeObject(objOrderModel)}", bLogWrite);

            ServiceResult<OrderModel> lo_objResult = null;
            IDasNetCom                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objOrderModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objOrderModel.OrderItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",              DBType.adVarChar,   objOrderModel.OrderLocationCode,             5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objOrderModel.OrderClientCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objOrderModel.OrderClientName,               50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objOrderModel.OrderClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargePosition",      DBType.adVarWChar,  objOrderModel.OrderClientChargePosition,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelExtNo",      DBType.adVarChar,   objOrderModel.OrderClientChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelNo",         DBType.adVarChar,   objOrderModel.OrderClientChargeTelNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeCell",          DBType.adVarChar,   objOrderModel.OrderClientChargeCell,         20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objOrderModel.PayClientCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objOrderModel.PayClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objOrderModel.PayClientChargeName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargePosition",        DBType.adVarWChar,  objOrderModel.PayClientChargePosition,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeTelExtNo",        DBType.adVarChar,   objOrderModel.PayClientChargeTelExtNo,       20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeTelNo",           DBType.adVarChar,   objOrderModel.PayClientChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeCell",            DBType.adVarChar,   objOrderModel.PayClientChargeCell,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objOrderModel.PayClientChargeLocation,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",                  DBType.adBigInt,    objOrderModel.ConsignorCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objOrderModel.ConsignorName,                 50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objOrderModel.PickupYMD,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",                      DBType.adVarWChar,  objOrderModel.PickupWay,                     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objOrderModel.PickupHM,                      4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objOrderModel.PickupPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objOrderModel.PickupPlacePost,               6,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objOrderModel.PickupPlaceAddr,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objOrderModel.PickupPlaceAddrDtl,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objOrderModel.PickupPlaceFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objOrderModel.PickupPlaceChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objOrderModel.PickupPlaceChargeTelNo,        20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objOrderModel.PickupPlaceChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objOrderModel.PickupPlaceChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objOrderModel.PickupPlaceChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",           DBType.adVarChar,   objOrderModel.PickupPlaceLocalCode,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",           DBType.adVarWChar,  objOrderModel.PickupPlaceLocalName,          50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objOrderModel.PickupPlaceNote,               300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                         DBType.adVarChar,   objOrderModel.GetYMD,                        8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetWay",                         DBType.adVarWChar,  objOrderModel.GetWay,                        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                          DBType.adVarChar,   objOrderModel.GetHM,                         4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                       DBType.adVarWChar,  objOrderModel.GetPlace,                      200,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlacePost",                   DBType.adVarChar,   objOrderModel.GetPlacePost,                  6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddr",                   DBType.adVarWChar,  objOrderModel.GetPlaceAddr,                  100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",                DBType.adVarWChar,  objOrderModel.GetPlaceAddrDtl,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceFullAddr",               DBType.adVarWChar,  objOrderModel.GetPlaceFullAddr,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelExtNo",         DBType.adVarChar,   objOrderModel.GetPlaceChargeTelExtNo,        20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceChargeTelNo",            DBType.adVarChar,   objOrderModel.GetPlaceChargeTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeCell",             DBType.adVarChar,   objOrderModel.GetPlaceChargeCell,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeName",             DBType.adVarWChar,  objOrderModel.GetPlaceChargeName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargePosition",         DBType.adVarWChar,  objOrderModel.GetPlaceChargePosition,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceLocalCode",              DBType.adVarChar,   objOrderModel.GetPlaceLocalCode,             20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceLocalName",              DBType.adVarWChar,  objOrderModel.GetPlaceLocalName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceNote",                   DBType.adVarWChar,  objOrderModel.GetPlaceNote,                  300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objOrderModel.NoteClient,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteInside",                     DBType.adVarWChar,  objOrderModel.NoteInside,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",                     DBType.adVarChar,   objOrderModel.CarTonCode,                    5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTypeCode",                    DBType.adVarChar,   objOrderModel.CarTypeCode,                   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoLayerFlag",                    DBType.adChar,      objOrderModel.NoLayerFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoTopFlag",                      DBType.adChar,      objOrderModel.NoTopFlag,                     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",                        DBType.adChar,      objOrderModel.FTLFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportFlag",              DBType.adChar,      objOrderModel.ArrivalReportFlag,             1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCustomFlag",                     DBType.adChar,      objOrderModel.CustomFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objOrderModel.BondedFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDocumentFlag",                   DBType.adChar,      objOrderModel.DocumentFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLicenseFlag",                    DBType.adChar,      objOrderModel.LicenseFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInTimeFlag",                     DBType.adChar,      objOrderModel.InTimeFlag,                    1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strControlFlag",                    DBType.adChar,      objOrderModel.ControlFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuickGetFlag",                   DBType.adChar,      objOrderModel.QuickGetFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderFPISFlag",                  DBType.adChar,      objOrderModel.OrderFPISFlag,                 1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsDispatchType",              DBType.adTinyInt,   objOrderModel.GoodsDispatchType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsName",                      DBType.adVarWChar,  objOrderModel.GoodsName,                     100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objOrderModel.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                         DBType.adInteger,   objOrderModel.Length,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                            DBType.adDouble,    objOrderModel.CBM,                           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuantity",                       DBType.adVarWChar,  objOrderModel.Quantity,                      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objOrderModel.Volume,                        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objOrderModel.Weight,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNation",                         DBType.adVarWChar,  objOrderModel.Nation,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                           DBType.adVarChar,   objOrderModel.Hawb,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMawb",                           DBType.adVarChar,   objOrderModel.Mawb,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInvoiceNo",                      DBType.adVarChar,   objOrderModel.InvoiceNo,                     50,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objOrderModel.BookingNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStockNo",                        DBType.adVarChar,   objOrderModel.StockNo,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGMOrderType",                    DBType.adVarWChar,  objOrderModel.GMOrderType,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGMTripID",                       DBType.adVarWChar,  objOrderModel.GMTripID,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsNote",                      DBType.adVarWChar,  objOrderModel.GoodsNote,                     500,     ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objOrderModel.GoodsRunType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",                   DBType.adChar,      objOrderModel.CarFixedFlag,                  1,       ParameterDirection.Input);    // 2023-03-16 by shadow54 : 자동운임 수정 건
                lo_objDas.AddParam("@pi_strLayoverFlag",                    DBType.adChar,      objOrderModel.LayoverFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSamePlaceCount",                 DBType.adInteger,   objOrderModel.SamePlaceCount,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNonSamePlaceCount",              DBType.adInteger,   objOrderModel.NonSamePlaceCount,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTaxClientName",                  DBType.adVarWChar,  objOrderModel.TaxClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientCorpNo",                DBType.adVarChar,   objOrderModel.TaxClientCorpNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientChargeName",            DBType.adVarWChar,  objOrderModel.TaxClientChargeName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientChargeTelNo",           DBType.adVarChar,   objOrderModel.TaxClientChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientChargeEmail",           DBType.adVarChar,   objOrderModel.TaxClientChargeEmail,          256,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intQuickType",                      DBType.adTinyInt,   objOrderModel.QuickType,                     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",                       DBType.adBigInt,    objOrderModel.RefSeqNo,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",               DBType.adTinyInt,   objOrderModel.InsureExceptKind,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderStatus",                    DBType.adTinyInt,   objOrderModel.OrderStatus,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderRegType",                   DBType.adTinyInt,   objOrderModel.OrderRegType,                  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intReqSeqNo",                       DBType.adBigInt,    objOrderModel.ReqSeqNo,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWoSeqNo",                        DBType.adBigInt,    objOrderModel.WoSeqNo,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",                     DBType.adVarChar,   objOrderModel.RegAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",                   DBType.adVarWChar,  objOrderModel.RegAdminName,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intOrderNo",                        DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intAddSeqNo",                       DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGoodsSeqNo",                     DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDispatchSeqNo",                  DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_TX_INS");
                
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
                objOrderModel.OrderNo       = lo_objDas.GetParam("@po_intOrderNo").ToInt64();
                objOrderModel.AddSeqNo      = lo_objDas.GetParam("@po_intAddSeqNo").ToInt64();
                objOrderModel.GoodsSeqNo    = lo_objDas.GetParam("@po_intGoodsSeqNo").ToInt64();
                objOrderModel.DispatchSeqNo = lo_objDas.GetParam("@po_intDispatchSeqNo").ToInt64();
                lo_objResult.data           = objOrderModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 수정
        /// </summary>
        /// <param name="objOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderUpd> SetOrderUpd(OrderModel objOrderModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderUpd REQ] {JsonConvert.SerializeObject(objOrderModel)}", bLogWrite);

            ServiceResult<ResOrderUpd> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objOrderModel.CenterCode,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                        DBType.adBigInt,    objOrderModel.OrderNo,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objOrderModel.OrderItemCode,                5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",              DBType.adVarChar,   objOrderModel.OrderLocationCode,            5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objOrderModel.OrderClientCode,              0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objOrderModel.OrderClientName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objOrderModel.OrderClientChargeName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargePosition",      DBType.adVarWChar,  objOrderModel.OrderClientChargePosition,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelExtNo",      DBType.adVarChar,   objOrderModel.OrderClientChargeTelExtNo,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelNo",         DBType.adVarChar,   objOrderModel.OrderClientChargeTelNo,       20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeCell",          DBType.adVarChar,   objOrderModel.OrderClientChargeCell,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objOrderModel.PayClientCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objOrderModel.PayClientName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objOrderModel.PayClientChargeName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargePosition",        DBType.adVarWChar,  objOrderModel.PayClientChargePosition,      20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeTelExtNo",        DBType.adVarChar,   objOrderModel.PayClientChargeTelExtNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeTelNo",           DBType.adVarChar,   objOrderModel.PayClientChargeTelNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeCell",            DBType.adVarChar,   objOrderModel.PayClientChargeCell,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objOrderModel.PayClientChargeLocation,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",                  DBType.adBigInt,    objOrderModel.ConsignorCode,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objOrderModel.ConsignorName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objOrderModel.PickupYMD,                    8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",                      DBType.adVarWChar,  objOrderModel.PickupWay,                    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objOrderModel.PickupHM,                     4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objOrderModel.PickupPlace,                  200,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objOrderModel.PickupPlacePost,              6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objOrderModel.PickupPlaceAddr,              100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objOrderModel.PickupPlaceAddrDtl,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objOrderModel.PickupPlaceFullAddr,          150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objOrderModel.PickupPlaceChargeTelExtNo,    20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objOrderModel.PickupPlaceChargeTelNo,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objOrderModel.PickupPlaceChargeCell,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objOrderModel.PickupPlaceChargeName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objOrderModel.PickupPlaceChargePosition,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",           DBType.adVarChar,   objOrderModel.PickupPlaceLocalCode,         20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",           DBType.adVarWChar,  objOrderModel.PickupPlaceLocalName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objOrderModel.PickupPlaceNote,              300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                         DBType.adVarChar,   objOrderModel.GetYMD,                       8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetWay",                         DBType.adVarWChar,  objOrderModel.GetWay,                       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                          DBType.adVarChar,   objOrderModel.GetHM,                        4,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlace",                       DBType.adVarWChar,  objOrderModel.GetPlace,                     200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlacePost",                   DBType.adVarChar,   objOrderModel.GetPlacePost,                 6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddr",                   DBType.adVarWChar,  objOrderModel.GetPlaceAddr,                 100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",                DBType.adVarWChar,  objOrderModel.GetPlaceAddrDtl,              100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceFullAddr",               DBType.adVarWChar,  objOrderModel.GetPlaceFullAddr,             150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceChargeTelExtNo",         DBType.adVarChar,   objOrderModel.GetPlaceChargeTelExtNo,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelNo",            DBType.adVarChar,   objOrderModel.GetPlaceChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeCell",             DBType.adVarChar,   objOrderModel.GetPlaceChargeCell,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeName",             DBType.adVarWChar,  objOrderModel.GetPlaceChargeName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargePosition",         DBType.adVarWChar,  objOrderModel.GetPlaceChargePosition,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceLocalCode",              DBType.adVarChar,   objOrderModel.GetPlaceLocalCode,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceLocalName",              DBType.adVarWChar,  objOrderModel.GetPlaceLocalName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceNote",                   DBType.adVarWChar,  objOrderModel.GetPlaceNote,                 300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objOrderModel.NoteClient,                   1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteInside",                     DBType.adVarWChar,  objOrderModel.NoteInside,                   1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",                     DBType.adVarChar,   objOrderModel.CarTonCode,                   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",                    DBType.adVarChar,   objOrderModel.CarTypeCode,                  5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoLayerFlag",                    DBType.adChar,      objOrderModel.NoLayerFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoTopFlag",                      DBType.adChar,      objOrderModel.NoTopFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",                        DBType.adChar,      objOrderModel.FTLFlag,                      1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strArrivalReportFlag",              DBType.adChar,      objOrderModel.ArrivalReportFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustomFlag",                     DBType.adChar,      objOrderModel.CustomFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objOrderModel.BondedFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDocumentFlag",                   DBType.adChar,      objOrderModel.DocumentFlag,                 1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLicenseFlag",                    DBType.adChar,      objOrderModel.LicenseFlag,                  1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strInTimeFlag",                     DBType.adChar,      objOrderModel.InTimeFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strControlFlag",                    DBType.adChar,      objOrderModel.ControlFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuickGetFlag",                   DBType.adChar,      objOrderModel.QuickGetFlag,                 1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderFPISFlag",                  DBType.adChar,      objOrderModel.OrderFPISFlag,                1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",                     DBType.adBigInt,    objOrderModel.GoodsSeqNo,                   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intGoodsDispatchType",              DBType.adTinyInt,   objOrderModel.GoodsDispatchType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsName",                      DBType.adVarWChar,  objOrderModel.GoodsName,                    100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objOrderModel.GoodsItemCode,                5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                         DBType.adInteger,   objOrderModel.Length,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                            DBType.adDouble,    objOrderModel.CBM,                          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strQuantity",                       DBType.adVarWChar,  objOrderModel.Quantity,                     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objOrderModel.Volume,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objOrderModel.Weight,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNation",                         DBType.adVarWChar,  objOrderModel.Nation,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                           DBType.adVarChar,   objOrderModel.Hawb,                         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMawb",                           DBType.adVarChar,   objOrderModel.Mawb,                         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInvoiceNo",                      DBType.adVarChar,   objOrderModel.InvoiceNo,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objOrderModel.BookingNo,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStockNo",                        DBType.adVarChar,   objOrderModel.StockNo,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGMOrderType",                    DBType.adVarWChar,  objOrderModel.GMOrderType,                  50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGMTripID",                       DBType.adVarWChar,  objOrderModel.GMTripID,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsNote",                      DBType.adVarWChar,  objOrderModel.GoodsNote,                    500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objOrderModel.GoodsRunType,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",                   DBType.adChar,      objOrderModel.CarFixedFlag,                 1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayoverFlag",                    DBType.adChar,      objOrderModel.LayoverFlag,                  1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intSamePlaceCount",                 DBType.adInteger,   objOrderModel.SamePlaceCount,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNonSamePlaceCount",              DBType.adInteger,   objOrderModel.NonSamePlaceCount,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientName",                  DBType.adVarWChar,  objOrderModel.TaxClientName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientCorpNo",                DBType.adVarChar,   objOrderModel.TaxClientCorpNo,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientChargeName",            DBType.adVarWChar,  objOrderModel.TaxClientChargeName,          50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTaxClientChargeTelNo",           DBType.adVarChar,   objOrderModel.TaxClientChargeTelNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxClientChargeEmail",           DBType.adVarChar,   objOrderModel.TaxClientChargeEmail,         256,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",                      DBType.adTinyInt,   objOrderModel.QuickType,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",                       DBType.adBigInt,    objOrderModel.RefSeqNo,                     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",               DBType.adTinyInt,   objOrderModel.InsureExceptKind,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intChgSeqNo",                       DBType.adBigInt,    objOrderModel.ChgSeqNo,                     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",                     DBType.adVarChar,   objOrderModel.UpdAdminID,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",                   DBType.adVarWChar,  objOrderModel.UpdAdminName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strSaleClosingFlag",                DBType.adVarChar,   DBNull.Value,                               1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPurchaseClosingFlag",            DBType.adVarChar,   DBNull.Value,                               1,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_TX_UPD");
                
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

                lo_objResult.data = new ResOrderUpd
                {
                    SaleClosingFlag     = lo_objDas.GetParam("@po_strSaleClosingFlag"),
                    PurchaseClosingFlag = lo_objDas.GetParam("@po_strPurchaseClosingFlag")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderList> GetOrderList(ReqOrderList objReqOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderList REQ] {JsonConvert.SerializeObject(objReqOrderList)}", bLogWrite);
            
            string                      lo_strJson   = string.Empty;
            ServiceResult<ResOrderList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",                    DBType.adBigInt,    objReqOrderList.OrderNo,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                 DBType.adInteger,   objReqOrderList.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",                   DBType.adTinyInt,   objReqOrderList.ListType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                   DBType.adTinyInt,   objReqOrderList.DateType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                   DBType.adVarChar,   objReqOrderList.DateFrom,                  8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",                     DBType.adVarChar,   objReqOrderList.DateTo,                    8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",         DBType.adVarChar,   objReqOrderList.OrderLocationCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",             DBType.adVarChar,   objReqOrderList.OrderItemCodes,            4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderStatuses",              DBType.adVarChar,   objReqOrderList.OrderStatuses,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",            DBType.adVarWChar,  objReqOrderList.OrderClientName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeName",      DBType.adVarWChar,  objReqOrderList.OrderClientChargeName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",              DBType.adVarWChar,  objReqOrderList.PayClientName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",        DBType.adVarWChar,  objReqOrderList.PayClientChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",    DBType.adVarWChar,  objReqOrderList.PayClientChargeLocation,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",              DBType.adVarWChar,  objReqOrderList.ConsignorName,             50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlace",                DBType.adVarWChar,  objReqOrderList.PickupPlace,               200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGETPlace",                   DBType.adVarWChar,  objReqOrderList.GetPlace,                  200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsName",                  DBType.adVarWChar,  objReqOrderList.GoodsName,                 100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                    DBType.adVarWChar,  objReqOrderList.ComName,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",                  DBType.adVarChar,   objReqOrderList.ComCorpNo,                 20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDriverName",                 DBType.adVarWChar,  objReqOrderList.DriverName,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                      DBType.adVarWChar,  objReqOrderList.CarNo,                     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                 DBType.adVarWChar,  objReqOrderList.NoteClient,                1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransCenterCode",            DBType.adInteger,   objReqOrderList.TransCenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode",         DBType.adInteger,   objReqOrderList.ContractCenterCode,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCsAdminID",                  DBType.adVarChar,   objReqOrderList.CsAdminID,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",            DBType.adVarWChar,  objReqOrderList.AcceptAdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyChargeFlag",               DBType.adChar,      objReqOrderList.MyChargeFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",                DBType.adChar,      objReqOrderList.MyOrderFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                    DBType.adChar,      objReqOrderList.CnlFlag,                   1,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intSortType",                   DBType.adTinyInt,   objReqOrderList.SortType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                    DBType.adVarChar,   objReqOrderList.AdminID,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",           DBType.adVarChar,   objReqOrderList.AccessCenterCode,          512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                   DBType.adInteger,   objReqOrderList.PageSize,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                     DBType.adInteger,   objReqOrderList.PageNo,                    0,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@po_intRecordCnt",                  DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderList
                {
                    list = new List<OrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("ContractStatusMView", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["ContractStatusMView"] = row["ContractStatusM"].ToString();

                        if (row["ContractStatusM"].ToString().Equals("위탁") && row["ContractInfo"].ToString().IndexOf("/", StringComparison.Ordinal) > -1)
                        {
                            row["ContractStatusMView"] += "접수";
                        }
                    }
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 취소
        /// </summary>
        /// <param name="objOrderCnl"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderCnl> SetOrderCnl(ReqOrderCnl objOrderCnl)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderCnl REQ] {JsonConvert.SerializeObject(objOrderCnl)}", bLogWrite);

            ServiceResult<ResOrderCnl> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderCnl>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos",           DBType.adVarChar,   objOrderCnl.OrderNos,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objOrderCnl.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlReason",          DBType.adVarWChar,  objOrderCnl.CnlReason,         500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",         DBType.adVarChar,   objOrderCnl.CnlAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",       DBType.adVarWChar,  objOrderCnl.CnlAdminName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objOrderCnl.AccessCenterCode,  512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,   objOrderCnl.GradeCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",           DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCancelCnt",          DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_TX_CNL");

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

                lo_objResult.data           = new ResOrderCnl
                {
                    TotalCnt  = lo_objDas.GetParam("@po_intTotalCnt").ToInt(),
                    CancelCnt = lo_objDas.GetParam("@po_intCancelCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 목록
        /// </summary>
        /// <param name="objReqOrderPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayList> GetOrderPayList(int intCenterCode, Int64 intOrderNo, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayList REQ] {intCenterCode} | {intOrderNo} | {strAccessCenterCode}", bLogWrite);
            
            string                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderPayList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   intCenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   strAccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayList
                {
                    list      = new List<OrderPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 비용 등록
        /// </summary>
        /// <param name="objOrderPayModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderPayModel> SetOrderPayIns(OrderPayModel objOrderPayModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayIns REQ] {JsonConvert.SerializeObject(objOrderPayModel)}", bLogWrite);

            ServiceResult<OrderPayModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderPayModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objOrderPayModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",          DBType.adBigInt,    objOrderPayModel.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",       DBType.adBigInt,    objOrderPayModel.GoodsSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",    DBType.adBigInt,    objOrderPayModel.DispatchSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",          DBType.adTinyInt,   objOrderPayModel.PayType,          0,       ParameterDirection.Input);
                                                              
                lo_objDas.AddParam("@pi_intTaxKind",          DBType.adTinyInt,   objOrderPayModel.TaxKind,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",         DBType.adVarChar,   objOrderPayModel.ItemCode,         5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",       DBType.adBigInt,    objOrderPayModel.ClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",       DBType.adVarWChar,  objOrderPayModel.ClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",        DBType.adCurrency,  objOrderPayModel.SupplyAmt,        0,       ParameterDirection.Input);
                                                              
                lo_objDas.AddParam("@pi_intTaxAmt",           DBType.adCurrency,  objOrderPayModel.TaxAmt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransDtlSeqNo",    DBType.adBigInt,    objOrderPayModel.TransDtlSeqNo,    0,       ParameterDirection.Input);    // 2023-03-16 by shadow54 : 자동운임 수정 건
                lo_objDas.AddParam("@pi_intApplySeqNo",       DBType.adBigInt,    objOrderPayModel.ApplySeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransRateStatus",  DBType.adTinyInt,   objOrderPayModel.TransRateStatus,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",       DBType.adVarChar,   objOrderPayModel.RegAdminID,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminName",     DBType.adVarWChar,  objOrderPayModel.RegAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",            DBType.adBigInt,    DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_TX_INS");


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
                objOrderPayModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objOrderPayModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderPayIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 비용 수정
        /// </summary>
        /// <param name="objOrderPayModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderPayUpd(OrderPayModel objOrderPayModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayUpd REQ] {JsonConvert.SerializeObject(objOrderPayModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",             DBType.adBigInt,    objOrderPayModel.SeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objOrderPayModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objOrderPayModel.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",        DBType.adBigInt,    objOrderPayModel.GoodsSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",     DBType.adBigInt,    objOrderPayModel.DispatchSeqNo,    0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPayType",           DBType.adTinyInt,   objOrderPayModel.PayType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxKind",           DBType.adTinyInt,   objOrderPayModel.TaxKind,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",          DBType.adVarChar,   objOrderPayModel.ItemCode,         5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,    objOrderPayModel.ClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",        DBType.adVarWChar,  objOrderPayModel.ClientName,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intSupplyAmt",         DBType.adCurrency,  objOrderPayModel.SupplyAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxAmt",            DBType.adCurrency,  objOrderPayModel.TaxAmt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransDtlSeqNo",     DBType.adBigInt,    objOrderPayModel.TransDtlSeqNo,    0,       ParameterDirection.Input);    // 2023-03-16 by shadow54 : 자동운임 수정 건
                lo_objDas.AddParam("@pi_intApplySeqNo",        DBType.adBigInt,    objOrderPayModel.ApplySeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransRateStatus",   DBType.adTinyInt,   objOrderPayModel.TransRateStatus,  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",        DBType.adVarChar,   objOrderPayModel.UpdAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",      DBType.adVarWChar,  objOrderPayModel.UpdAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_TX_UPD");


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
                                     , 9101, "System error(SetOrderPayUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 비용 삭제
        /// </summary>
        /// <param name="objOrderPayModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderPayDel(long intSeqNo, int intCenterCode, long intOrderNo, int intPayType, string strAdminID, string strAdminName)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayDel REQ] {intSeqNo} | {intCenterCode} | {intOrderNo} | {intPayType} | {strAdminID} | {strAdminName}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",         DBType.adBigInt,    intSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   intCenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    intOrderNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",       DBType.adTinyInt,   intPayType,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",    DBType.adVarChar,   strAdminID,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDelAdminName",  DBType.adVarWChar,  strAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_TX_DEL");


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
                                     , 9101, "System error(SetOrderPayDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPayDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        

        /// <summary>
        /// 오더 복사 달력 조회
        /// </summary>
        /// <returns></returns>
        public ServiceResult<ResOrderCopyCalendarList> GetOrderCopyCalendarList()
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderCopyCalendar REQ]", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResOrderCopyCalendarList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderCopyCalendarList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.SetQuery("dbo.UP_ORDER_COPY_CALENDAR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderCopyCalendarList
                {
                    list = new List<OrderCopyCalendarModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderCopyCalendarModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderCopyCalendar)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderCopyCalendar RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더 복사
        /// </summary>
        /// <param name="objReqOrderCopyIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetContainerOrderCopyIns(ReqOrderCopyIns objReqOrderCopyIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetContainerOrderCopyIns REQ] {JsonConvert.SerializeObject(objReqOrderCopyIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objReqOrderCopyIns.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",        DBType.adVarChar,   objReqOrderCopyIns.OrderNos,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderCnt",        DBType.adInteger,   objReqOrderCopyIns.OrderCnt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMDs",      DBType.adVarChar,   objReqOrderCopyIns.PickupYMDs,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsFlag",       DBType.adChar,      objReqOrderCopyIns.GoodsFlag,          1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNoteFlag",        DBType.adChar,      objReqOrderCopyIns.NoteFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClientFlag",  DBType.adChar,      objReqOrderCopyIns.NoteClientFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar,   objReqOrderCopyIns.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",       DBType.adVarWChar,  objReqOrderCopyIns.AdminName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTeamCode",   DBType.adVarChar,   objReqOrderCopyIns.AdminTeamCode,      5,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_COPY_TX_INS");


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
                                     , 9101, "System error(SetContainerOrderCopyIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetContainerOrderCopyIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 수출입 오더 복사
        /// </summary>
        /// <param name="objReqOrderCopyIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetInoutOrderCopyIns(ReqOrderCopyIns objReqOrderCopyIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetInoutOrderCopyIns REQ] {JsonConvert.SerializeObject(objReqOrderCopyIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderCopyIns.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",           DBType.adVarChar,   objReqOrderCopyIns.OrderNos,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderCnt",           DBType.adInteger,   objReqOrderCopyIns.OrderCnt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMDs",         DBType.adVarChar,   objReqOrderCopyIns.PickupYMDs,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGetYMDType",         DBType.adTinyInt,   objReqOrderCopyIns.GetYMDType,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNoteFlag",           DBType.adChar,      objReqOrderCopyIns.NoteFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClientFlag",     DBType.adChar,      objReqOrderCopyIns.NoteClientFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportFlag",  DBType.adChar,      objReqOrderCopyIns.ArrivalReportFlag, 1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustomFlag",         DBType.adChar,      objReqOrderCopyIns.CustomFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",         DBType.adChar,      objReqOrderCopyIns.BondedFlag,        1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strInTimeFlag",         DBType.adChar,      objReqOrderCopyIns.InTimeFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuickGetFlag",       DBType.adChar,      objReqOrderCopyIns.QuickGetFlag,      1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsFlag",          DBType.adChar,      objReqOrderCopyIns.GoodsFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxChargeFlag",      DBType.adChar,      objReqOrderCopyIns.TaxChargeFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqOrderCopyIns.AdminID,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminName",          DBType.adVarWChar,  objReqOrderCopyIns.AdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTeamCode",      DBType.adVarChar,   objReqOrderCopyIns.AdminTeamCode,     5,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_INOUT_COPY_TX_INS");


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
                                     , 9101, "System error(SetInoutOrderCopyIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetInoutOrderCopyIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 내수 오더 복사
        /// </summary>
        /// <param name="objReqOrderCopyIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetDomesticOrderCopyIns(ReqOrderCopyIns objReqOrderCopyIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetDomesticOrderCopyIns REQ] {JsonConvert.SerializeObject(objReqOrderCopyIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objReqOrderCopyIns.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",        DBType.adVarChar,   objReqOrderCopyIns.OrderNos,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderCnt",        DBType.adInteger,   objReqOrderCopyIns.OrderCnt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMDs",      DBType.adVarChar,   objReqOrderCopyIns.PickupYMDs,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGetYMDType",      DBType.adTinyInt,   objReqOrderCopyIns.GetYMDType,        0,       ParameterDirection.Input);
                                                             
                lo_objDas.AddParam("@pi_strDispatchFlag",    DBType.adChar,      objReqOrderCopyIns.DispatchFlag,      1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsFlag",       DBType.adChar,      objReqOrderCopyIns.GoodsFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteFlag",        DBType.adChar,      objReqOrderCopyIns.NoteFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClientFlag",  DBType.adChar,      objReqOrderCopyIns.NoteClientFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar,   objReqOrderCopyIns.AdminID,           50,      ParameterDirection.Input);
                                                             
                lo_objDas.AddParam("@pi_strAdminName",       DBType.adVarWChar,  objReqOrderCopyIns.AdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTeamCode",   DBType.adVarChar,   objReqOrderCopyIns.AdminTeamCode,     5,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                                                                                                                       
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DOMESTIC_COPY_TX_INS");

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
                                     , 9101, "System error(SetDomesticOrderCopyIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetDomesticOrderCopyIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 사업장 변경
        /// </summary>
        /// <param name="strOrderNos"></param>
        /// <param name="intCenterCode"></param>
        /// <param name="strOrderLocationCode"></param>
        /// <param name="strAdminID"></param>
        /// <param name="strAdminName"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderLocationUpd(string strOrderNos, int intCenterCode, string strOrderLocationCode, string strAdminID, string strAdminName)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderLocationUpd REQ] {strOrderNos} | {intCenterCode} | {strOrderLocationCode} | {strAdminID} | {strAdminName}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_strOrderNos",            DBType.adVarChar,   strOrderNos,            8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   intCenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",   DBType.adVarChar,   strOrderLocationCode,   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   strAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",           DBType.adVarWChar,  strAdminName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_LOCATION_TX_UPD");


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
                                     , 9101, "System error(SetOrderLocationUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderLocationUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배차 목록
        /// </summary>
        /// <param name="intCenterCode"></param>
        /// <param name="intOrderNo"></param>
        /// <param name="intGoodsSeqNo"></param>
        /// <param name="strAccessCenterCode"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchCarList> GetOrderDispatchCarList(int intCenterCode, Int64 intOrderNo, long intGoodsSeqNo, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderDispatchCarList REQ] {intCenterCode} | {intOrderNo} | {intGoodsSeqNo} | {strAccessCenterCode}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchCarList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchCarList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   intCenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    intOrderNo,            0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",        DBType.adBigInt,    intGoodsSeqNo,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   strAccessCenterCode,   512,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,          0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_CAR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchCarList
                {
                    list      = new List<OrderDispatchCarGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchCarGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderDispatchCarList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderDispatchCarList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배차 상하차 상태 업데이트
        /// </summary>
        /// <param name="objReqOrderDispatchCarStatus"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderDispatchCarStatusUpd(ReqOrderDispatchCarStatusUpd objReqOrderDispatchCarStatus)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderDispatchCarStatusUpd REQ] {JsonConvert.SerializeObject(objReqOrderDispatchCarStatus)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqOrderDispatchCarStatus.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",  DBType.adBigInt,    objReqOrderDispatchCarStatus.DispatchSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupDT",       DBType.adVarChar,   objReqOrderDispatchCarStatus.PickupDT,          16,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalDT",      DBType.adVarChar,   objReqOrderDispatchCarStatus.ArrivalDT,         16,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetDT",          DBType.adVarChar,   objReqOrderDispatchCarStatus.GetDT,             16,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqOrderDispatchCarStatus.AdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",      DBType.adVarWChar,  objReqOrderDispatchCarStatus.AdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_CAR_STATUS_TX_UPD");


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
                                     , 9101, "System error(SetOrderDispatchCarStatusUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderDispatchCarStatusUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 서비스 이슈 목록
        /// </summary>
        /// <param name="objReqOrderSQIList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderSQIList> GetOrderSQIList(ReqOrderSQIList objReqOrderSQIList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQIList REQ] {JsonConvert.SerializeObject(objReqOrderSQIList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderSQIList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderSQIList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSQISeqNo",               DBType.adBigInt,    objReqOrderSQIList.SQISeqNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqOrderSQIList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objReqOrderSQIList.OrderNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqOrderSQIList.DateFrom,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqOrderSQIList.DateTo,                8,       ParameterDirection.Input);
                                                                                                                                  
                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objReqOrderSQIList.OrderLocationCodes,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objReqOrderSQIList.OrderItemCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",        DBType.adVarWChar,  objReqOrderSQIList.OrderClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",          DBType.adVarWChar,  objReqOrderSQIList.PayClientName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",          DBType.adVarWChar,  objReqOrderSQIList.ConsignorName,         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOrderType",              DBType.adTinyInt,   objReqOrderSQIList.OrderType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",                DBType.adChar,      objReqOrderSQIList.DelFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqOrderSQIList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",               DBType.adInteger,   objReqOrderSQIList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                 DBType.adInteger,   objReqOrderSQIList.PageNo,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",              DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderSQIList
                {
                    list = new List<OrderSQIGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderSQIGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderSQIList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQIList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 오더 서비스 이슈 등록
        /// </summary>
        /// <param name="objOrderSQIModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderSQIModel> SetOrderSQIIns(OrderSQIModel objOrderSQIModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIIns REQ] {JsonConvert.SerializeObject(objOrderSQIModel)}", bLogWrite);

            ServiceResult<OrderSQIModel> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<OrderSQIModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objOrderSQIModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,    objOrderSQIModel.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intItemSeqNo",      DBType.adInteger,   objOrderSQIModel.ItemSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYMD",            DBType.adVarChar,   objOrderSQIModel.YMD,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDetail",         DBType.adVarWChar,  objOrderSQIModel.Detail,           200,     ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strTeam",           DBType.adVarWChar,  objOrderSQIModel.Team,             2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContents",       DBType.adVarWChar,  objOrderSQIModel.Contents,         2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAction",         DBType.adVarWChar,  objOrderSQIModel.Action,           2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCause",          DBType.adVarWChar,  objOrderSQIModel.Cause,            2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFollowUp",       DBType.adVarWChar,  objOrderSQIModel.FollowUp,         2000,    ParameterDirection.Input);
                                                                                                                   
                lo_objDas.AddParam("@pi_strCost",           DBType.adVarWChar,  objOrderSQIModel.Cost,             2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMeasure",        DBType.adVarWChar,  objOrderSQIModel.Measure,          2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objOrderSQIModel.RegAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objOrderSQIModel.RegAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSQISeqNo",       DBType.adBigInt,    DBNull.Value,                      0,       ParameterDirection.Output);
                                                            
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_TX_INS");

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

                lo_objResult.data          = objOrderSQIModel;
                lo_objResult.data.SQISeqNo = lo_objDas.GetParam("@po_intSQISeqNo").ToInt64();
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderSQIIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 서비스 이슈 수정
        /// </summary>
        /// <param name="objOrderSQIModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderSQIUpd(OrderSQIModel objOrderSQIModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIUpd REQ] {JsonConvert.SerializeObject(objOrderSQIModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objOrderSQIModel.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,    objOrderSQIModel.OrderNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSQISeqNo",       DBType.adBigInt,    objOrderSQIModel.SQISeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intItemSeqNo",      DBType.adInteger,   objOrderSQIModel.ItemSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYMD",            DBType.adVarChar,   objOrderSQIModel.YMD,               8,       ParameterDirection.Input);
                                                                                                                    
                lo_objDas.AddParam("@pi_strDetail",         DBType.adVarWChar,  objOrderSQIModel.Detail,            200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTeam",           DBType.adVarWChar,  objOrderSQIModel.Team,              2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContents",       DBType.adVarWChar,  objOrderSQIModel.Contents,          2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAction",         DBType.adVarWChar,  objOrderSQIModel.Action,            2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCause",          DBType.adVarWChar,  objOrderSQIModel.Cause,             2000,    ParameterDirection.Input);
                                                                                                                    
                lo_objDas.AddParam("@pi_strFollowUp",       DBType.adVarWChar,  objOrderSQIModel.FollowUp,          2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCost",           DBType.adVarWChar,  objOrderSQIModel.Cost,              2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMeasure",        DBType.adVarWChar,  objOrderSQIModel.Measure,           2000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objOrderSQIModel.UpdAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",   DBType.adVarWChar,  objOrderSQIModel.UpdAdminName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_TX_UPD");

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
                                     , 9101, "System error(SetOrderSQIUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 서비스 이슈 삭제
        /// </summary>
        /// <param name="objOrderSQIModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderSQIDel(OrderSQIModel objOrderSQIModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIDel REQ] {JsonConvert.SerializeObject(objOrderSQIModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objOrderSQIModel.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    objOrderSQIModel.OrderNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSQISeqNo",      DBType.adBigInt,    objOrderSQIModel.SQISeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",    DBType.adVarChar,   objOrderSQIModel.DelAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",  DBType.adVarWChar,  objOrderSQIModel.DelAdminName,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_TX_DEL");

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
                                     , 9101, "System error(SetOrderSQIDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQIDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 서비스 이슈 유형 목록
        /// </summary>
        /// <param name="objReqOrderSQIItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderSQIItemList> GetOrderSQIItemList(ReqOrderSQIItemList objReqOrderSQIItemList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQIItemList REQ] {JsonConvert.SerializeObject(objReqOrderSQIItemList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResOrderSQIItemList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderSQIItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intItemSeqNo",         DBType.adBigInt,    objReqOrderSQIItemList.ItemSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqOrderSQIItemList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderItemCode",     DBType.adVarChar,   objReqOrderSQIItemList.OrderItemCode,       5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqOrderSQIItemList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",           DBType.adChar,      objReqOrderSQIItemList.DelFlag,             1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqOrderSQIItemList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqOrderSQIItemList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_ITEM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderSQIItemList
                {
                    list = new List<OrderSQIItemGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderSQIItemGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderSQIItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQIItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 서비스 이슈 댓글 목록
        /// </summary>
        /// <param name="objReqOrderSQICommentList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderSQICommentList> GetOrderSQICommentList(ReqOrderSQICommentList objReqOrderSQICommentList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQICommentList REQ] {JsonConvert.SerializeObject(objReqOrderSQICommentList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResOrderSQICommentList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderSQICommentList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSQISeqNo",          DBType.adBigInt,    objReqOrderSQICommentList.SQISeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqOrderSQICommentList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqOrderSQICommentList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",           DBType.adChar,      objReqOrderSQICommentList.DelFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqOrderSQICommentList.PageSize,            0,       ParameterDirection.Input);
                                                                                                                                  
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqOrderSQICommentList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_COMMENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderSQICommentList
                {
                    list = new List<OrderSQICommentGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderSQICommentGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderSQICommentList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderSQICommentList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 서비스 이슈 댓글 등록
        /// </summary>
        /// <param name="objOrderSQICommentModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderSQICommentModel> SetOrderSQICommentIns(OrderSQICommentModel objOrderSQICommentModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQICommentIns REQ] {JsonConvert.SerializeObject(objOrderSQICommentModel)}", bLogWrite);

            ServiceResult<OrderSQICommentModel> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderSQICommentModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objOrderSQICommentModel.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSQISeqNo",       DBType.adBigInt,    objOrderSQICommentModel.SQISeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContents",       DBType.adVarWChar,  objOrderSQICommentModel.Contents,        500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objOrderSQICommentModel.RegAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objOrderSQICommentModel.RegAdminName,    50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intCommentSeqNo",   DBType.adBigInt,    DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_COMMENT_TX_INS");

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

                lo_objResult.data = objOrderSQICommentModel;
                lo_objResult.data.CommentSeqNo = lo_objDas.GetParam("@po_intCommentSeqNo").ToInt64();
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderSQICommentIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQICommentIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 서비스 이슈 댓글 삭제
        /// </summary>
        /// <param name="objOrderSQICommentModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderSQICommentDel(OrderSQICommentModel objOrderSQICommentModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQICommentDel REQ] {JsonConvert.SerializeObject(objOrderSQICommentModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCommentSeqNo", DBType.adBigInt,    objOrderSQICommentModel.CommentSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",   DBType.adVarChar,   objOrderSQICommentModel.DelAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName", DBType.adVarWChar,  objOrderSQICommentModel.DelAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SQI_COMMENT_TX_DEL");

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
                                     , 9101, "System error(SetOrderSQICommentDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderSQICommentDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 정보망 목록
        /// </summary>
        /// <param name="objReqOrderNetworkList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderNetworkList> GetOrderNetworkList(ReqOrderNetworkList objReqOrderNetworkList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderNetworkList REQ] {JsonConvert.SerializeObject(objReqOrderNetworkList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResOrderNetworkList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderNetworkList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intNetworkNo",            DBType.adBigInt,    objReqOrderNetworkList.NetworkNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqOrderNetworkList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqOrderNetworkList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqOrderNetworkList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkStatus",        DBType.adTinyInt,   objReqOrderNetworkList.NetworkStatus,       0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNetworkRenewalFlag",   DBType.adChar,      objReqOrderNetworkList.NetworkRenewalFlag,  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                DBType.adVarWChar,  objReqOrderNetworkList.CarNo,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",           DBType.adVarWChar,  objReqOrderNetworkList.DriverName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",           DBType.adVarWChar,  objReqOrderNetworkList.DriverCell,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",         DBType.adVarWChar,  objReqOrderNetworkList.RegAdminName,        50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqOrderNetworkList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqOrderNetworkList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqOrderNetworkList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderNetworkList
                {
                    list      = new List<OrderNetworkGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderNetworkGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderNetworkList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderNetworkList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 정보망 등록
        /// </summary>
        /// <param name="objOrderNetworkModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderNetworkModel> SetOrderNetworkIns(OrderNetworkModel objOrderNetworkModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkIns REQ] {JsonConvert.SerializeObject(objOrderNetworkModel)}", bLogWrite);

            ServiceResult<OrderNetworkModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderNetworkModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objOrderNetworkModel.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",              DBType.adVarChar,   objOrderNetworkModel.OrderNos,               8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",          DBType.adTinyInt,   objOrderNetworkModel.DispatchType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCode",  DBType.adVarChar,   objOrderNetworkModel.DeliveryLocationCode,   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOrderNo",        DBType.adVarChar,   objOrderNetworkModel.NetworkOrderNo,         50,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_intNetworkKind",           DBType.adTinyInt,   objOrderNetworkModel.NetworkKind,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",             DBType.adVarChar,   objOrderNetworkModel.PickupYMD,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",              DBType.adVarChar,   objOrderNetworkModel.PickupHM,               4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",           DBType.adVarWChar,  objOrderNetworkModel.PickupPlace,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupAddr",            DBType.adVarWChar,  objOrderNetworkModel.PickupAddr,             100,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strPickupAddrDtl",         DBType.adVarWChar,  objOrderNetworkModel.PickupAddrDtl,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                DBType.adVarChar,   objOrderNetworkModel.GetYMD,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                 DBType.adVarChar,   objOrderNetworkModel.GetHM,                  4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",              DBType.adVarWChar,  objOrderNetworkModel.GetPlace,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetAddr",               DBType.adVarWChar,  objOrderNetworkModel.GetAddr,                100,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strGetAddrDtl",            DBType.adVarWChar,  objOrderNetworkModel.GetAddrDtl,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",                DBType.adVarWChar,  objOrderNetworkModel.CarTon,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTruck",              DBType.adVarWChar,  objOrderNetworkModel.CarTruck,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",             DBType.adVarWChar,  objOrderNetworkModel.PickupWay,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetWay",                DBType.adVarWChar,  objOrderNetworkModel.GetWay,                 20,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_intWeight",                DBType.adInteger,   objOrderNetworkModel.Weight,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                  DBType.adVarWChar,  objOrderNetworkModel.Note,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayerFlag",             DBType.adChar,      objOrderNetworkModel.LayerFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUrgentFlag",            DBType.adChar,      objOrderNetworkModel.UrgentFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShuttleFlag",           DBType.adChar,      objOrderNetworkModel.ShuttleFlag,            1,       ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_intQuickType",             DBType.adTinyInt,   objOrderNetworkModel.QuickType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayPlanYMD",            DBType.adVarChar,   objOrderNetworkModel.PayPlanYMD,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",             DBType.adCurrency,  objOrderNetworkModel.SupplyAmt,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxAmt",                DBType.adCurrency,  objOrderNetworkModel.TaxAmt,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkMsg",            DBType.adVarWChar,  objOrderNetworkModel.NetworkMsg,             100,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strNetworkRenewalFlag",    DBType.adChar,      objOrderNetworkModel.NetworkRenewalFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRuleSeqNo",             DBType.adInteger,   objOrderNetworkModel.RuleSeqNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalPurchasePrice",  DBType.adCurrency,  objOrderNetworkModel.RenewalPurchasePrice,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalLimitPrice",     DBType.adCurrency,  objOrderNetworkModel.RenewalLimitPrice,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",            DBType.adVarChar,   objOrderNetworkModel.RegAdminID,             50,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strRegAdminName",          DBType.adVarWChar,  objOrderNetworkModel.RegAdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intNetworkSeqNo",          DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intNetworkNo",             DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                                                                   
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_TX_INS");

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
                objOrderNetworkModel.NetworkNo    = lo_objDas.GetParam("@po_intNetworkNo").ToInt64();
                objOrderNetworkModel.NetworkSeqNo = lo_objDas.GetParam("@po_intNetworkSeqNo").ToInt64();
                lo_objResult.data                 = objOrderNetworkModel;

            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderNetworkIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 정보망 수정
        /// </summary>
        /// <param name="objOrderNetworkModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderNetworkUpd(OrderNetworkModel objOrderNetworkModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkUpd REQ] {JsonConvert.SerializeObject(objOrderNetworkModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intNetworkSeqNo",           DBType.adBigInt,    objOrderNetworkModel.NetworkSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objOrderNetworkModel.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",              DBType.adVarChar,   objOrderNetworkModel.PickupYMD,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",               DBType.adVarChar,   objOrderNetworkModel.PickupHM,              4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",            DBType.adVarWChar,  objOrderNetworkModel.PickupPlace,           100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupAddr",             DBType.adVarWChar,  objOrderNetworkModel.PickupAddr,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupAddrDtl",          DBType.adVarWChar,  objOrderNetworkModel.PickupAddrDtl,         100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                 DBType.adVarChar,   objOrderNetworkModel.GetYMD,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                  DBType.adVarChar,   objOrderNetworkModel.GetHM,                 4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",               DBType.adVarWChar,  objOrderNetworkModel.GetPlace,              100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetAddr",                DBType.adVarWChar,  objOrderNetworkModel.GetAddr,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetAddrDtl",             DBType.adVarWChar,  objOrderNetworkModel.GetAddrDtl,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",                 DBType.adVarWChar,  objOrderNetworkModel.CarTon,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTruck",               DBType.adVarWChar,  objOrderNetworkModel.CarTruck,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",              DBType.adVarWChar,  objOrderNetworkModel.PickupWay,             20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetWay",                 DBType.adVarWChar,  objOrderNetworkModel.GetWay,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                 DBType.adInteger,   objOrderNetworkModel.Weight,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                   DBType.adVarWChar,  objOrderNetworkModel.Note,                  200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayerFlag",              DBType.adChar,      objOrderNetworkModel.LayerFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUrgentFlag",             DBType.adChar,      objOrderNetworkModel.UrgentFlag,            1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShuttleFlag",            DBType.adChar,      objOrderNetworkModel.ShuttleFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",              DBType.adTinyInt,   objOrderNetworkModel.QuickType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayPlanYMD",             DBType.adVarChar,   objOrderNetworkModel.PayPlanYMD,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",              DBType.adCurrency,  objOrderNetworkModel.SupplyAmt,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxAmt",                 DBType.adCurrency,  objOrderNetworkModel.TaxAmt,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intNetworkStatus",          DBType.adTinyInt,   objOrderNetworkModel.NetworkStatus,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkMsg",             DBType.adVarWChar,  objOrderNetworkModel.NetworkMsg,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkRenewalFlag",     DBType.adChar,      objOrderNetworkModel.NetworkRenewalFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRuleSeqNo",              DBType.adInteger,   objOrderNetworkModel.RuleSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalPurchasePrice",   DBType.adCurrency,  objOrderNetworkModel.RenewalPurchasePrice,  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intRenewalLimitPrice",      DBType.adCurrency,  objOrderNetworkModel.RenewalLimitPrice,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",             DBType.adVarChar,   objOrderNetworkModel.UpdAdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",           DBType.adVarWChar,  objOrderNetworkModel.UpdAdminName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_TX_UPD");

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
                                     , 9101, "System error(SetOrderNetworkUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 정보망 배차 취소
        /// </summary>
        /// <param name="objReqOrderNetworkCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderNetworkDispatchCnl(ReqOrderNetworkCnl objReqOrderNetworkCnl)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkDispatchCnl REQ] {JsonConvert.SerializeObject(objReqOrderNetworkCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intNetworkNo",  DBType.adBigInt,    objReqOrderNetworkCnl.NetworkNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objReqOrderNetworkCnl.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,   objReqOrderNetworkCnl.CnlAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",  DBType.adVarWChar,  objReqOrderNetworkCnl.CnlAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                                                                                                                  
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_DISPATCH_TX_CNL");

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
                                     , 9101, "System error(SetOrderNetworkDispatchCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkDispatchCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 오더 정보망 취소
        /// </summary>
        /// <param name="objReqOrderNetworkCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderNetworkCnl(ReqOrderNetworkCnl objReqOrderNetworkCnl)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkCnl REQ] {JsonConvert.SerializeObject(objReqOrderNetworkCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intNetworkNo",  DBType.adBigInt,    objReqOrderNetworkCnl.NetworkNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objReqOrderNetworkCnl.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,   objReqOrderNetworkCnl.CnlAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",  DBType.adVarWChar,  objReqOrderNetworkCnl.CnlAdminName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                                                                                                                   
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_TX_CNL");

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
                                     , 9101, "System error(SetOrderNetworkCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 송금예정일 조회
        /// </summary>
        /// <param name="objReqPlanYMDGet"></param>
        /// <returns></returns>
        public ServiceResult<ResPlanYMDGet> GetPlanYMD(ReqPlanYMDGet objReqPlanYMDGet)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetPlanYMD REQ] {JsonConvert.SerializeObject(objReqPlanYMDGet)}", bLogWrite);

            ServiceResult<ResPlanYMDGet> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPlanYMDGet>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strYMD",           DBType.adVarChar,   objReqPlanYMDGet.YMD,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAddDateCnt",    DBType.adInteger,   objReqPlanYMDGet.AddDateCnt,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHolidayFlag",   DBType.adChar,      objReqPlanYMDGet.HolidayFlag,   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strPlanYMD",       DBType.adVarChar,   DBNull.Value,                   8,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                   256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PLAN_YMD_NT_GET");

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

                lo_objResult.data = new ResPlanYMDGet
                {
                    PlanYMD = lo_objDas.GetParam("@po_strPlanYMD")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPlanYMD)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetPlanYMD RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 정보망 오더번호 수정
        /// </summary>
        /// <param name="objOrderNetworkModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderNetworkOrderNoUpd(int intCenterCode, long intNetworkNo, string strNetworkOrderNo)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkOrderNoUpd REQ] {intCenterCode} | {intNetworkNo} | {strNetworkOrderNo}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   intCenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkNo",        DBType.adBigInt,    intNetworkNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOrderNo",   DBType.adVarChar,   strNetworkOrderNo,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,         0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,         0,       ParameterDirection.Output);


                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_ORDERNO_TX_UPD");

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
                                     , 9101, "System error(SetOrderNetworkOrderNoUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderNetworkOrderNoUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 오더 목록
        /// </summary>
        public ServiceResult<ResAdminBookmarkOrderList> GetAdminBookmarkOrderList(ReqAdminBookmarkOrderList objReqAdminBookmarkOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetAdminBookmarkOrderList REQ] {JsonConvert.SerializeObject(objReqAdminBookmarkOrderList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResAdminBookmarkOrderList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminBookmarkOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderSeqNo",    DBType.adInteger,   objReqAdminBookmarkOrderList.OrderSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqAdminBookmarkOrderList.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBookmarkName",  DBType.adVarWChar,  objReqAdminBookmarkOrderList.BookmarkName,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",    DBType.adVarChar,   objReqAdminBookmarkOrderList.RegAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",      DBType.adInteger,   objReqAdminBookmarkOrderList.PageSize,      0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",        DBType.adInteger,   objReqAdminBookmarkOrderList.PageNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);
                  
                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminBookmarkOrderList
                {
                    list = new List<AdminBookmarkOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminBookmarkOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminBookmarkOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetAdminBookmarkOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 오더 등록
        /// </summary>
        /// <param name="objAdminBookmarkOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<AdminBookmarkOrderModel> SetAdminBookmarkOrderIns(AdminBookmarkOrderModel objAdminBookmarkOrderModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkOrderIns REQ] {JsonConvert.SerializeObject(objAdminBookmarkOrderModel)}", bLogWrite);

            ServiceResult<AdminBookmarkOrderModel> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminBookmarkOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objAdminBookmarkOrderModel.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    objAdminBookmarkOrderModel.OrderNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBookmarkName",  DBType.adVarWChar,  objAdminBookmarkOrderModel.BookmarkName,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",    DBType.adVarChar,   objAdminBookmarkOrderModel.RegAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",  DBType.adVarWChar,  objAdminBookmarkOrderModel.RegAdminName,  50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intOrderSeqNo",    DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ORDER_TX_INS");

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

                objAdminBookmarkOrderModel.OrderSeqNo = lo_objDas.GetParam("@po_intOrderSeqNo").ToInt();
                lo_objResult.data                     = objAdminBookmarkOrderModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetAdminBookmarkOrderIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkOrderIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 오더 삭제
        /// </summary>
        /// <param name="intOrderSeqNo"></param>
        /// <param name="strAdminID"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetAdminBookmarkOrderDel(int intOrderSeqNo, string strAdminID)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkOrderDel REQ] {intOrderSeqNo} | {strAdminID}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;
            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderSeqNo",   DBType.adInteger,   intOrderSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",   DBType.adVarChar,   strAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,   DBNull.Value,    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,   DBNull.Value,    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,   DBNull.Value,    256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,   DBNull.Value,    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ORDER_TX_DEL");

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
                                     , 9101, "System error(SetAdminBookmarkOrderDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkOrderDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 주소(정보망) 목록
        /// </summary>
        public ServiceResult<ResAdminBookmarkAddrList> GetAdminBookmarkAddrList(ReqAdminBookmarkAddrList objReqAdminBookmarkAddrList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetAdminBookmarkAddrList REQ] {JsonConvert.SerializeObject(objReqAdminBookmarkAddrList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResAdminBookmarkAddrList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminBookmarkAddrList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intAddrSeqNo",    DBType.adInteger,   objReqAdminBookmarkAddrList.AddrSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddrName",     DBType.adVarWChar,  objReqAdminBookmarkAddrList.AddrName,      100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddr",         DBType.adVarWChar,  objReqAdminBookmarkAddrList.Addr,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",   DBType.adVarChar,   objReqAdminBookmarkAddrList.RegAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",     DBType.adInteger,   objReqAdminBookmarkAddrList.PageSize,      0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",       DBType.adInteger,   objReqAdminBookmarkAddrList.PageNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",    DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);
                 
                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ADDR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminBookmarkAddrList
                {
                    list = new List<AdminBookmarkAddrModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminBookmarkAddrModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAdminBookmarkAddrList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetAdminBookmarkAddrList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 주소(정보망) 등록
        /// </summary>
        /// <param name="objAdminBookmarkAddrModel"></param>
        /// <returns></returns>
        public ServiceResult<AdminBookmarkAddrModel> SetAdminBookmarkAddrIns(AdminBookmarkAddrModel objAdminBookmarkAddrModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkAddrIns REQ] {JsonConvert.SerializeObject(objAdminBookmarkAddrModel)}", bLogWrite);

            ServiceResult<AdminBookmarkAddrModel> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<AdminBookmarkAddrModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAddrName",       DBType.adVarWChar,  objAdminBookmarkAddrModel.AddrName,       100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddr",           DBType.adVarWChar,  objAdminBookmarkAddrModel.Addr,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddrDtl",        DBType.adVarWChar,  objAdminBookmarkAddrModel.AddrDtl,        100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objAdminBookmarkAddrModel.RegAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objAdminBookmarkAddrModel.RegAdminName,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intAddrSeqNo",      DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ADDR_TX_INS");

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
                objAdminBookmarkAddrModel.AddrSeqNo = lo_objDas.GetParam("@po_intAddrSeqNo").ToInt();
                lo_objResult.data                   = objAdminBookmarkAddrModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetAdminBookmarkAddrIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkAddrIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 사용자 즐겨찾기 주소(정보망) 삭제
        /// </summary>
        /// <param name="intAddrSeqNo"></param>
        /// <param name="strAdminID"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetAdminBookmarkAddrDel(int intAddrSeqNo, string strAdminID)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkAddrDel REQ] {intAddrSeqNo} | {strAdminID}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intAddrSeqNo",   DBType.adInteger,   intAddrSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",  DBType.adVarChar,   strAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,   DBNull.Value,   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,   DBNull.Value,   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,   DBNull.Value,   256,     ParameterDirection.Output);
                                                         
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,   DBNull.Value,   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ADMIN_BOOKMARK_ADDR_TX_DEL");

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
                                     , 9101, "System error(SetAdminBookmarkAddrDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetAdminBookmarkAddrDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 정보망 오더 배차 목록
        /// </summary>
        /// <param name="intCenterCode"></param>
        /// <param name="intNetworkNo"></param>
        /// <param name="strAccessCenterCode"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderNetworkDispatchList> GetOrderNetworkDispatchCarList(int intCenterCode, Int64 intNetworkNo, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderNetworkDispatchCarList REQ] {intCenterCode} | {intNetworkNo} {strAccessCenterCode}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResOrderNetworkDispatchList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderNetworkDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   intCenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkNo",         DBType.adBigInt,    intNetworkNo,          0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   strAccessCenterCode,   512,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,          0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_DISPATCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderNetworkDispatchList
                {
                    list      = new List<OrderNetworkDispatchCarGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderNetworkDispatchCarGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderNetworkDispatchCarList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderNetworkDispatchCarList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 수정 요청 목록
        /// </summary>
        /// <param name="objReqOrderAmtRequestOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderAmtRequestOrderList> GetOrderAmtRequestOrderList(ReqOrderAmtRequestOrderList objReqOrderAmtRequestOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderAmtRequestOrderList REQ] {JsonConvert.SerializeObject(objReqOrderAmtRequestOrderList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResOrderAmtRequestOrderList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderAmtRequestOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objReqOrderAmtRequestOrderList.OrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqOrderAmtRequestOrderList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",          DBType.adTinyInt,   objReqOrderAmtRequestOrderList.ListType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",           DBType.adTinyInt,   objReqOrderAmtRequestOrderList.PayType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",          DBType.adTinyInt,   objReqOrderAmtRequestOrderList.DateType,           0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateFrom",          DBType.adVarChar,   objReqOrderAmtRequestOrderList.DateFrom,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",            DBType.adVarChar,   objReqOrderAmtRequestOrderList.DateTo,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",     DBType.adVarWChar,  objReqOrderAmtRequestOrderList.ConsignorName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",     DBType.adVarWChar,  objReqOrderAmtRequestOrderList.PayClientName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",             DBType.adVarWChar,  objReqOrderAmtRequestOrderList.CarNo,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMyChargeFlag",      DBType.adChar,      objReqOrderAmtRequestOrderList.MyChargeFlag,       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",       DBType.adChar,      objReqOrderAmtRequestOrderList.MyOrderFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqStatus",         DBType.adTinyInt,   objReqOrderAmtRequestOrderList.ReqStatus,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,   objReqOrderAmtRequestOrderList.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqOrderAmtRequestOrderList.AccessCenterCode,   512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqOrderAmtRequestOrderList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqOrderAmtRequestOrderList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AMT_REQUEST_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderAmtRequestOrderList
                {
                    list      = new List<OrderAmtRequestOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderAmtRequestOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderAmtRequestOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderAmtRequestOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 수정 요청 승인 목록
        /// </summary>
        /// <param name="objReqOrderAmtRequestList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderAmtRequestList> GetOrderAmtRequestList(ReqOrderAmtRequestList objReqOrderAmtRequestList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderAmtRequestList REQ] {JsonConvert.SerializeObject(objReqOrderAmtRequestList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResOrderAmtRequestList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderAmtRequestList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDtlSeqNo",          DBType.adBigInt,    objReqOrderAmtRequestList.DtlSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objReqOrderAmtRequestList.OrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqOrderAmtRequestList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",          DBType.adTinyInt,   objReqOrderAmtRequestList.ListType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",           DBType.adTinyInt,   objReqOrderAmtRequestList.PayType,            0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDateType",          DBType.adTinyInt,   objReqOrderAmtRequestList.DateType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",          DBType.adVarChar,   objReqOrderAmtRequestList.DateFrom,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",            DBType.adVarChar,   objReqOrderAmtRequestList.DateTo,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",     DBType.adVarWChar,  objReqOrderAmtRequestList.ConsignorName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",     DBType.adVarWChar,  objReqOrderAmtRequestList.PayClientName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarNo",             DBType.adVarWChar,  objReqOrderAmtRequestList.CarNo,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyChargeFlag",      DBType.adChar,      objReqOrderAmtRequestList.MyChargeFlag,       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",       DBType.adChar,      objReqOrderAmtRequestList.MyOrderFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqAdminName",      DBType.adVarWChar,  objReqOrderAmtRequestList.ReqAdminName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqStatus",         DBType.adTinyInt,   objReqOrderAmtRequestList.ReqStatus,          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,   objReqOrderAmtRequestList.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqOrderAmtRequestList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqOrderAmtRequestList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqOrderAmtRequestList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AMT_REQUEST_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderAmtRequestList
                {
                    list      = new List<OrderAmtRequestGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderAmtRequestGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderAmtRequestList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderAmtRequestList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 수정 요청 등록
        /// </summary>
        /// <param name="objOrderAmtRequestModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderAmtRequestModel> SetOrderAmtRequestIns(OrderAmtRequestModel objOrderAmtRequestModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestIns REQ] {JsonConvert.SerializeObject(objOrderAmtRequestModel)}", bLogWrite);

            ServiceResult<OrderAmtRequestModel> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderAmtRequestModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objOrderAmtRequestModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,    objOrderAmtRequestModel.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqKind",        DBType.adTinyInt,   objOrderAmtRequestModel.ReqKind,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPaySeqNo",       DBType.adBigInt,    objOrderAmtRequestModel.PaySeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqSupplyAmt",   DBType.adCurrency,  objOrderAmtRequestModel.ReqSupplyAmt,     0,       ParameterDirection.Input);
                                                                                                                          
                lo_objDas.AddParam("@pi_intReqTaxAmt",      DBType.adCurrency,  objOrderAmtRequestModel.ReqTaxAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqReason",      DBType.adVarWChar,  objOrderAmtRequestModel.ReqReason,        500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objOrderAmtRequestModel.RegAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objOrderAmtRequestModel.RegAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",          DBType.adBigInt,    DBNull.Value,                             0,       ParameterDirection.Output);
                                                                                                                         
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AMT_REQUEST_TX_INS");

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
                objOrderAmtRequestModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt64();
                lo_objResult.data = objOrderAmtRequestModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderAmtRequestIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 수정 요청 승인, 반려
        /// </summary>
        /// <param name="objReqOrderAmtRequestStatusUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderAmtRequestStatusUpd(ReqOrderAmtRequestStatusUpd objReqOrderAmtRequestStatusUpd)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestStatusUpd REQ] {JsonConvert.SerializeObject(objReqOrderAmtRequestStatusUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",         DBType.adBigInt,    objReqOrderAmtRequestStatusUpd.SeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqStatus",     DBType.adTinyInt,   objReqOrderAmtRequestStatusUpd.ReqStatus,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",    DBType.adVarChar,   objReqOrderAmtRequestStatusUpd.UpdAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",  DBType.adVarWChar,  objReqOrderAmtRequestStatusUpd.UpdAdminName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                                                                                                                               
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AMT_REQUEST_STATUS_TX_UPD");

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
                                     , 9101, "System error(SetOrderAmtRequestStatusUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestStatusUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 수정 요청 취소
        /// </summary>
        /// <param name="objReqOrderAmtRequestCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderAmtRequestCnl(ReqOrderAmtRequestCnl objReqOrderAmtRequestCnl)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestCnl REQ] {JsonConvert.SerializeObject(objReqOrderAmtRequestCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",         DBType.adBigInt,    objReqOrderAmtRequestCnl.SeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",    DBType.adVarChar,   objReqOrderAmtRequestCnl.CnlAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",  DBType.adVarWChar,  objReqOrderAmtRequestCnl.CnlAdminName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                                                                                                                        
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_AMT_REQUEST_TX_CNL");

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
                                     , 9101, "System error(SetOrderAmtRequestCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderAmtRequestCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 내수오더 카운트
        /// </summary>
        /// <param name="objReqDomesticOrderCount"></param>
        /// <returns></returns>
        public ServiceResult<ResDomesticOrderCount> GetDomesticOrderCount(ReqDomesticOrderCount objReqDomesticOrderCount)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetDomesticOrderCount REQ] {JsonConvert.SerializeObject(objReqDomesticOrderCount)}", bLogWrite);

            ServiceResult<ResDomesticOrderCount> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDomesticOrderCount>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqDomesticOrderCount.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqDomesticOrderCount.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intWebRegRequestCnt",   DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intWebUpdRequestCnt",   DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAmtRequestCnt",      DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intNetworkDispatchCnt", DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DOMESTIC_COUNT_NT_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDomesticOrderCount
                {
                    WebRegRequestCnt   = lo_objDas.GetParam("@po_intWebRegRequestCnt").ToInt(),
                    WebUpdRequestCnt   = lo_objDas.GetParam("@po_intWebUpdRequestCnt").ToInt(),
                    AmtRequestCnt      = lo_objDas.GetParam("@po_intAmtRequestCnt").ToInt(),
                    NetworkDispatchCnt = lo_objDas.GetParam("@po_intNetworkDispatchCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDomesticOrderCount)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetDomesticOrderCount RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 수출입오더 카운트
        /// </summary>
        /// <param name="objReqInoutOrderCount"></param>
        /// <returns></returns>
        public ServiceResult<ResInoutOrderCount> GetInoutOrderCount(ReqInoutOrderCount objReqInoutOrderCount)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetInoutOrderCount REQ] {JsonConvert.SerializeObject(objReqInoutOrderCount)}", bLogWrite);

            ServiceResult<ResInoutOrderCount> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResInoutOrderCount>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqInoutOrderCount.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intWebRegRequestCnt",   DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intWebUpdRequestCnt",   DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAmtRequestCnt",      DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_INOUT_COUNT_NT_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResInoutOrderCount
                {
                    WebRegRequestCnt = lo_objDas.GetParam("@po_intWebRegRequestCnt").ToInt(),
                    WebUpdRequestCnt = lo_objDas.GetParam("@po_intWebUpdRequestCnt").ToInt(),
                    AmtRequestCnt    = lo_objDas.GetParam("@po_intAmtRequestCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetInoutOrderCount)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetInoutOrderCount RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 이관 처리
        /// </summary>
        /// <param name="objReqOrderTransIns"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderTransIns> SetOrderTransIns(ReqOrderTransIns objReqOrderTransIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderTransIns REQ] {JsonConvert.SerializeObject(objReqOrderTransIns)}", bLogWrite);

            ServiceResult<ResOrderTransIns> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderTransIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqOrderTransIns.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqOrderTransIns.OrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTargetCenterCode",     DBType.adInteger,   objReqOrderTransIns.TargetCenterCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleOrgAmt",           DBType.adCurrency,  objReqOrderTransIns.SaleOrgAmt,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objReqOrderTransIns.AdminID,            50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminName",            DBType.adVarWChar,  objReqOrderTransIns.AdminName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTelNo",           DBType.adVarChar,   objReqOrderTransIns.AdminTelNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminMobileNo",        DBType.adVarChar,   objReqOrderTransIns.AdminMobileNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTargetOrderNo",        DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTargetDispatchSeqNo",  DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intTargetGoodsSeqNo",     DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTargetAddSeqNo",       DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_TRANS_REQ_TX_INS");

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

                lo_objResult.data = new ResOrderTransIns
                {
                    TargetOrderNo       = lo_objDas.GetParam("@po_intTargetOrderNo").ToInt64(),
                    TargetDispatchSeqNo = lo_objDas.GetParam("@po_intTargetDispatchSeqNo").ToInt64(),
                    TargetGoodsSeqNo    = lo_objDas.GetParam("@po_intTargetGoodsSeqNo").ToInt64(),
                    TargetAddSeqNo      = lo_objDas.GetParam("@po_intTargetAddSeqNo").ToInt64()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderTransIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderTransIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 위탁 처리
        /// </summary>
        /// <param name="objReqOrderContractIns"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderContractIns> SetOrderContractIns(ReqOrderContractIns objReqOrderContractIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderContractIns REQ] {JsonConvert.SerializeObject(objReqOrderContractIns)}", bLogWrite);

            ServiceResult<ResOrderContractIns> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderContractIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqOrderContractIns.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objReqOrderContractIns.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode",     DBType.adInteger,   objReqOrderContractIns.ContractCenterCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",           DBType.adTinyInt,   objReqOrderContractIns.DispatchType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqOrderContractIns.AdminID,              50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminName",              DBType.adVarWChar,  objReqOrderContractIns.AdminName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTelNo",             DBType.adVarChar,   objReqOrderContractIns.AdminTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminMobileNo",          DBType.adVarChar,   objReqOrderContractIns.AdminMobileNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intContractOrderNo",        DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractDispatchSeqNo",  DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intContractGoodsSeqNo",     DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractSaleSeqNo",      DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractAddSeqNo",       DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTRACT_REQ_TX_INS");

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

                lo_objResult.data = new ResOrderContractIns
                {
                    ContractOrderNo       = lo_objDas.GetParam("@po_intContractOrderNo").ToInt64(),
                    ContractDispatchSeqNo = lo_objDas.GetParam("@po_intContractDispatchSeqNo").ToInt64(),
                    ContractGoodsSeqNo    = lo_objDas.GetParam("@po_intContractGoodsSeqNo").ToInt64(),
                    ContractSaleSeqNo     = lo_objDas.GetParam("@po_intContractSaleSeqNo").ToInt64(),
                    ContractAddSeqNo      = lo_objDas.GetParam("@po_intContractAddSeqNo").ToInt64()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderContractIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderContractIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// DGF 오더 내역
        /// </summary>
        /// <param name="objReqDGFOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResDGFOrderList> GetDGFOrderList(ReqDGFOrderList objReqDGFOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetDGFOrderList REQ] {JsonConvert.SerializeObject(objReqDGFOrderList)}", bLogWrite);

            string                         lo_strJson           = string.Empty;
            ServiceResult<ResDGFOrderList> lo_objResult         = null;
            IDasNetCom                     lo_objDas            = null;
            string                         lo_strPickupFullAddr = string.Empty;
            string                         lo_strGetFullAddr    = string.Empty;

            try
            {
                lo_objResult = new ServiceResult<ResDGFOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqDGFOrderList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqDGFOrderList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqDGFOrderList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqDGFOrderList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",  DBType.adVarChar,   objReqDGFOrderList.OrderLocationCodes,  4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqDGFOrderList.OrderItemCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientCorpNos",    DBType.adVarChar,   objReqDGFOrderList.PayClientCorpNos,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqDGFOrderList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DGF_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDGFOrderList
                {
                    list      = new List<DGFOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("PickupPlaceSido",  typeof(string));
                    lo_objDas.objDT.Columns.Add("PickupPlaceGugun", typeof(string));
                    lo_objDas.objDT.Columns.Add("PickupPlaceDong",  typeof(string));
                    lo_objDas.objDT.Columns.Add("GetPlaceSido",  typeof(string));
                    lo_objDas.objDT.Columns.Add("GetPlaceGugun", typeof(string));
                    lo_objDas.objDT.Columns.Add("GetPlaceDong",  typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        lo_strPickupFullAddr = row["PickupPlaceFullAddr"].ToString();
                        lo_strGetFullAddr = row["GetPlaceFullAddr"].ToString();
                        if (!string.IsNullOrWhiteSpace(lo_strPickupFullAddr))
                        {
                            if (lo_strPickupFullAddr.Split(' ').Length.Equals(2))
                            {
                                row["PickupPlaceSido"]  = lo_strPickupFullAddr.Split(' ')[0];
                                row["PickupPlaceGugun"] = string.Empty; 
                                row["PickupPlaceDong"]  = lo_strPickupFullAddr.Split(' ')[1];
                            }
                            else if (lo_strPickupFullAddr.Split(' ').Length.Equals(3))
                            {
                                row["PickupPlaceSido"]  = lo_strPickupFullAddr.Split(' ')[0];
                                row["PickupPlaceGugun"] = lo_strPickupFullAddr.Split(' ')[1];
                                row["PickupPlaceDong"]  = lo_strPickupFullAddr.Split(' ')[2];
                            }
                            else if (lo_strPickupFullAddr.Split(' ').Length.Equals(4))
                            {
                                row["PickupPlaceSido"]  = lo_strPickupFullAddr.Split(' ')[0];
                                row["PickupPlaceGugun"] = lo_strPickupFullAddr.Split(' ')[1];
                                row["PickupPlaceDong"]  = lo_strPickupFullAddr.Substring(lo_strPickupFullAddr.IndexOf(row["PickupPlaceGugun"].ToString(), StringComparison.Ordinal) + row["PickupPlaceGugun"].ToString().Length);
                            }
                        }

                        if (!string.IsNullOrWhiteSpace(lo_strGetFullAddr))
                        {
                            if (lo_strGetFullAddr.Split(' ').Length.Equals(2))
                            {
                                row["GetPlaceSido"]  = lo_strGetFullAddr.Split(' ')[0];
                                row["GetPlaceGugun"] = string.Empty;
                                row["GetPlaceDong"]  = lo_strGetFullAddr.Split(' ')[1];
                            }
                            else if (lo_strGetFullAddr.Split(' ').Length.Equals(3))
                            {
                                row["GetPlaceSido"]  = lo_strGetFullAddr.Split(' ')[0];
                                row["GetPlaceGugun"] = lo_strGetFullAddr.Split(' ')[1];
                                row["GetPlaceDong"]  = lo_strGetFullAddr.Split(' ')[2];
                            }
                            else if (lo_strGetFullAddr.Split(' ').Length.Equals(4))
                            {
                                row["GetPlaceSido"] = lo_strGetFullAddr.Split(' ')[0];
                                row["GetPlaceGugun"] = lo_strGetFullAddr.Split(' ')[1];
                                row["GetPlaceDong"] = lo_strGetFullAddr.Substring(lo_strGetFullAddr.IndexOf(row["GetPlaceGugun"].ToString(), StringComparison.Ordinal) + row["GetPlaceGugun"].ToString().Length);
                            }
                        }
                    }
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DGFOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDGFOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetDGFOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GM 오더 내역
        /// </summary>
        /// <param name="objReqGMOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResGMOrderList> GetGMOrderList(ReqGMOrderList objReqGMOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetGMOrderList REQ] {JsonConvert.SerializeObject(objReqGMOrderList)}", bLogWrite);

            string                        lo_strJson        = string.Empty;
            ServiceResult<ResGMOrderList> lo_objResult      = null;
            IDasNetCom                    lo_objDas         = null;
            string                        lo_strQuantity    = string.Empty;
            string                        lo_strPickupYMDHM = string.Empty;

            try
            {
                lo_objResult = new ServiceResult<ResGMOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqGMOrderList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",             DBType.adTinyInt,   objReqGMOrderList.DateType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqGMOrderList.DateFrom,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqGMOrderList.DateTo,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlant",                DBType.adVarWChar,  objReqGMOrderList.Plant,                50,      ParameterDirection.Input);
                                                                                                                              
                lo_objDas.AddParam("@pi_strLocationAlias",        DBType.adVarWChar,  objReqGMOrderList.LocationAlias,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipper",              DBType.adVarWChar,  objReqGMOrderList.Shipper,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientCorpNos",   DBType.adVarChar,   objReqGMOrderList.OrderClientCorpNos,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientCorpNos",     DBType.adVarChar,   objReqGMOrderList.PayClientCorpNos,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqGMOrderList.AccessCenterCode,     512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_GM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResGMOrderList
                {
                    list      = new List<GMOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        lo_strQuantity    = row["Quantity"].ToString();
                        lo_strPickupYMDHM = row["PickupYMDHM"].ToString();

                        if (!string.IsNullOrWhiteSpace(lo_strQuantity))
                        {
                            if (lo_strQuantity.IndexOf("C/T", StringComparison.Ordinal) > -1)
                            {
                                row["CTVolume"] = row["Volume"].ToInt();
                            } 
                            else if (lo_strQuantity.IndexOf("P/T", StringComparison.Ordinal) > -1)
                            {
                                row["PTVolume"] = row["Volume"].ToInt();
                            }

                            row["Length"] = lo_strQuantity.Split(',')[0].Split(' ')[1].Split('*')[0].ToInt() * 10;
                            row["Width"]  = lo_strQuantity.Split(',')[0].Split('*')[1].ToInt() * 10;
                            row["Height"] = lo_strQuantity.Split(',')[0].Split('*')[2].ToInt() * 10;
                        }

                        if (!string.IsNullOrWhiteSpace(lo_strPickupYMDHM))
                        {
                            lo_strPickupYMDHM  = lo_strPickupYMDHM.Replace("오전", "AM");
                            lo_strPickupYMDHM  = lo_strPickupYMDHM.Replace("오후", "PM");
                            row["PickupYMDHM"] = lo_strPickupYMDHM;
                        }
                    }
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<GMOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetGMOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetGMOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GM 오더 등록
        /// </summary>
        /// <param name="objGMOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<GMOrderModel> SetGMOrderIns(GMOrderModel objGMOrderModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetGMOrderIns REQ] {JsonConvert.SerializeObject(objGMOrderModel)}", bLogWrite);

            ServiceResult<GMOrderModel> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<GMOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objGMOrderModel.CenterCode,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objGMOrderModel.OrderItemCode,               5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocation",                  DBType.adVarWChar,  objGMOrderModel.OrderLocation,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objGMOrderModel.OrderClientCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objGMOrderModel.OrderClientName,             50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objGMOrderModel.OrderClientChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargePosition",      DBType.adVarWChar,  objGMOrderModel.OrderClientChargePosition,   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelExtNo",      DBType.adVarChar,   objGMOrderModel.OrderClientChargeTelExtNo,   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelNo",         DBType.adVarChar,   objGMOrderModel.OrderClientChargeTelNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeCell",          DBType.adVarChar,   objGMOrderModel.OrderClientChargeCell,       20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objGMOrderModel.PayClientCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objGMOrderModel.PayClientName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objGMOrderModel.PayClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargePosition",        DBType.adVarWChar,  objGMOrderModel.PayClientChargePosition,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeTelExtNo",        DBType.adVarChar,   objGMOrderModel.PayClientChargeTelExtNo,     20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeTelNo",           DBType.adVarChar,   objGMOrderModel.PayClientChargeTelNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeCell",            DBType.adVarChar,   objGMOrderModel.PayClientChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objGMOrderModel.PayClientChargeLocation,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objGMOrderModel.PickupYMD,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objGMOrderModel.PickupHM,                    4,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetYMD",                         DBType.adVarChar,   objGMOrderModel.GetYMD,                      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                          DBType.adVarChar,   objGMOrderModel.GetHM,                       4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                       DBType.adVarWChar,  objGMOrderModel.GetPlace,                    200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlacePost",                   DBType.adVarChar,   objGMOrderModel.GetPlacePost,                6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddr",                   DBType.adVarWChar,  objGMOrderModel.GetPlaceAddr,                100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",                DBType.adVarWChar,  objGMOrderModel.GetPlaceAddrDtl,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceFullAddr",               DBType.adVarWChar,  objGMOrderModel.GetPlaceFullAddr,            150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelExtNo",         DBType.adVarChar,   objGMOrderModel.GetPlaceChargeTelExtNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelNo",            DBType.adVarChar,   objGMOrderModel.GetPlaceChargeTelNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeCell",             DBType.adVarChar,   objGMOrderModel.GetPlaceChargeCell,          20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceChargeName",             DBType.adVarWChar,  objGMOrderModel.GetPlaceChargeName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargePosition",         DBType.adVarWChar,  objGMOrderModel.GetPlaceChargePosition,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceLocalCode",              DBType.adVarChar,   objGMOrderModel.GetPlaceLocalCode,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceLocalName",              DBType.adVarWChar,  objGMOrderModel.GetPlaceLocalName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objGMOrderModel.NoteClient,                  1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intLength",                         DBType.adInteger,   objGMOrderModel.Length,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                            DBType.adDouble,    objGMOrderModel.CBM,                         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuantity",                       DBType.adVarWChar,  objGMOrderModel.Quantity,                    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objGMOrderModel.Volume,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objGMOrderModel.Weight,                      0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNation",                         DBType.adVarWChar,  objGMOrderModel.Nation,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                           DBType.adVarChar,   objGMOrderModel.Hawb,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMawb",                           DBType.adVarChar,   objGMOrderModel.Mawb,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInvoiceNo",                      DBType.adVarChar,   objGMOrderModel.InvoiceNo,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGMOrderType",                    DBType.adVarWChar,  objGMOrderModel.GMOrderType,                 50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGMTripID",                       DBType.adVarWChar,  objGMOrderModel.GMTripID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocationAlias",                  DBType.adVarWChar,  objGMOrderModel.LocationAlias,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipper",                        DBType.adVarWChar,  objGMOrderModel.Shipper,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrigin",                         DBType.adVarWChar,  objGMOrderModel.Origin,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",                     DBType.adVarChar,   objGMOrderModel.RegAdminID,                  50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminName",                   DBType.adVarWChar,  objGMOrderModel.RegAdminName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intOrderNo",                        DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAddSeqNo",                       DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGoodsSeqNo",                     DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDispatchSeqNo",                  DBType.adBigInt,    DBNull.Value,                                0,       ParameterDirection.Output);
                
                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_GM_TX_INS");

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
                objGMOrderModel.OrderNo       = lo_objDas.GetParam("@po_intOrderNo").ToInt64();
                objGMOrderModel.AddSeqNo      = lo_objDas.GetParam("@po_intAddSeqNo").ToInt64();
                objGMOrderModel.GoodsSeqNo    = lo_objDas.GetParam("@po_intGoodsSeqNo").ToInt64();
                objGMOrderModel.DispatchSeqNo = lo_objDas.GetParam("@po_intDispatchSeqNo").ToInt64();
                lo_objResult.data             = objGMOrderModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetGMOrderIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetGMOrderIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 비용항목 리스트
        /// </summary>
        /// <param name="objReqOrderPayItemStatementList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayItemStatementList> GetOrderPayItemStatementList(ReqOrderPayItemStatementList objReqOrderPayItemStatementList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayItemStatementList REQ] {JsonConvert.SerializeObject(objReqOrderPayItemStatementList)}", bLogWrite);

            string                                      lo_strJson   = string.Empty;
            ServiceResult<ResOrderPayItemStatementList> lo_objResult = null;
            IDasNetCom                                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayItemStatementList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqOrderPayItemStatementList.OrderNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqOrderPayItemStatementList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",            DBType.adTinyInt,   objReqOrderPayItemStatementList.ListType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqOrderPayItemStatementList.DateType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqOrderPayItemStatementList.DateFrom,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqOrderPayItemStatementList.DateTo,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",  DBType.adVarChar,   objReqOrderPayItemStatementList.OrderLocationCodes,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqOrderPayItemStatementList.OrderItemCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",     DBType.adVarWChar,  objReqOrderPayItemStatementList.OrderClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",       DBType.adVarWChar,  objReqOrderPayItemStatementList.PayClientName,         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objReqOrderPayItemStatementList.ConsignorName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayItemCode",         DBType.adVarChar,   objReqOrderPayItemStatementList.PayItemCode,           5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",        DBType.adTinyInt,   objReqOrderPayItemStatementList.DispatchType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",               DBType.adVarWChar,  objReqOrderPayItemStatementList.CarNo,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqOrderPayItemStatementList.AccessCenterCode,      512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_ITEM_STATEMENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayItemStatementList
                {
                    list      = new List<OrderPayItemStatementGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayItemStatementGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderPayItemStatementList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayItemStatementList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 비용 리스트
        /// </summary>
        /// <param name="objReqOrderPayStatementList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayStatementList> GetOrderPayStatementList(ReqOrderPayStatementList objReqOrderPayStatementList, List<OrderPayStatementPayItemGridModel> objPayItemList = null)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayStatementList REQ] {JsonConvert.SerializeObject(objReqOrderPayStatementList)}", bLogWrite);

            string                                  lo_strJson       = string.Empty;
            ServiceResult<ResOrderPayStatementList> lo_objResult     = null;
            IDasNetCom                              lo_objDas        = null;
            DataTable                               lo_objDataTable  = null;
            string                                  lo_strColumnName = string.Empty;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayStatementList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqOrderPayStatementList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqOrderPayStatementList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",            DBType.adTinyInt,   objReqOrderPayStatementList.ListType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",             DBType.adTinyInt,   objReqOrderPayStatementList.PayType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqOrderPayStatementList.DateType,            0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqOrderPayStatementList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqOrderPayStatementList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",  DBType.adVarChar,   objReqOrderPayStatementList.OrderLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqOrderPayStatementList.OrderItemCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",     DBType.adVarWChar,  objReqOrderPayStatementList.OrderClientName,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientName",       DBType.adVarWChar,  objReqOrderPayStatementList.PayClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objReqOrderPayStatementList.ConsignorName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",           DBType.adVarChar,   objReqOrderPayStatementList.CsAdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqOrderPayStatementList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_STATEMENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayStatementList
                {
                    list      = new List<OrderPayStatementGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDataTable = lo_objDas.objDT.Rows[0].Table;
                    SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayStatementList REQ] {JsonConvert.SerializeObject(lo_objDataTable)}", bLogWrite);
                    if (objPayItemList != null)
                    {
                        for (int i = 1; i <= 200; i++)
                        {
                            lo_strColumnName = "OP";
                            if (i < 10)
                            {
                                lo_strColumnName += "00" + i;
                            }
                            else if (i < 100)
                            {
                                lo_strColumnName += "0" + i;
                            }
                            else
                            {
                                lo_strColumnName += i;
                            }

                            if (!lo_objDataTable.Columns.Contains(lo_strColumnName))
                            {
                                lo_objDataTable.Columns.Add(lo_strColumnName, typeof(double));
                            }
                        }

                        foreach (DataRow row in lo_objDataTable.Rows)
                        {
                            for (int i = 1; i <= 200; i++)
                            {
                                lo_strColumnName = "OP";
                                if (i < 10)
                                {
                                    lo_strColumnName += "00" + i;
                                }
                                else if (i < 100)
                                {
                                    lo_strColumnName += "0" + i;
                                }
                                else
                                {
                                    lo_strColumnName += i;
                                }

                                row[lo_strColumnName] = 0;
                            }
                        }

                        foreach (DataRow row in lo_objDataTable.Rows)
                        {
                            foreach (var subRow in objPayItemList.FindAll(r => r.CenterCode.ToString().Equals(row["CenterCode"].ToString())).FindAll(r => r.OrderNo.ToString().Equals(row["OrderNo"].ToString())).FindAll(r => r.GoodsSeqNo.ToString().Equals(row["GoodsSeqNo"].ToString())))
                            {
                                row[subRow.ItemCode] = subRow.SupplyAmt;
                            }
                        }
                    }

                    lo_strJson = JsonConvert.SerializeObject(lo_objDataTable);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayStatementGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderPayStatementList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayStatementList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 리스트(비용항목)
        /// </summary>
        /// <param name="objReqOrderPayStatementPayItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayStatementPayItemList> GetOrderPayStatementPayItemList(ReqOrderPayStatementPayItemList objReqOrderPayStatementPayItemList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayStatementPayItemList REQ] {JsonConvert.SerializeObject(objReqOrderPayStatementPayItemList)}", bLogWrite);

            string                                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderPayStatementPayItemList> lo_objResult = null;
            IDasNetCom                                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayStatementPayItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqOrderPayStatementPayItemList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqOrderPayStatementPayItemList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",            DBType.adTinyInt,   objReqOrderPayStatementPayItemList.ListType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",             DBType.adTinyInt,   objReqOrderPayStatementPayItemList.PayType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqOrderPayStatementPayItemList.DateType,            0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqOrderPayStatementPayItemList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqOrderPayStatementPayItemList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",  DBType.adVarChar,   objReqOrderPayStatementPayItemList.OrderLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqOrderPayStatementPayItemList.OrderItemCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",     DBType.adVarWChar,  objReqOrderPayStatementPayItemList.OrderClientName,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientName",       DBType.adVarWChar,  objReqOrderPayStatementPayItemList.PayClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objReqOrderPayStatementPayItemList.ConsignorName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",           DBType.adVarChar,   objReqOrderPayStatementPayItemList.CsAdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqOrderPayStatementPayItemList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PAY_STATEMENT_PAY_ITEM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayStatementPayItemList
                {
                    list      = new List<OrderPayStatementPayItemGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayStatementPayItemGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderPayStatementPayItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderPayStatementPayItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 단건 취소
        /// </summary>
        /// <param name="objOrderOneCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderOneCnl(ReqOrderOneCnl objOrderOneCnl)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderOneCnl REQ] {JsonConvert.SerializeObject(objOrderOneCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objOrderOneCnl.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,    objOrderOneCnl.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlReason",      DBType.adVarWChar,  objOrderOneCnl.CnlReason,        500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",     DBType.adVarChar,   objOrderOneCnl.CnlAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",   DBType.adVarWChar,  objOrderOneCnl.CnlAdminName,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intChgSeqNo",       DBType.adBigInt,    objOrderOneCnl.ChgSeqNo,         0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_ONE_TX_CNL");

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
                                     , 9101, "System error(SetOrderOneCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderOneCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 이관매출 수정
        /// </summary>
        /// <param name="objReqOrderTransSaleUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderTransSaleUpd(ReqOrderTransSaleUpd objReqOrderTransSaleUpd)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderTransSaleUpd REQ] {JsonConvert.SerializeObject(objReqOrderTransSaleUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqOrderTransSaleUpd.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    objReqOrderTransSaleUpd.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleSeqNos",    DBType.adVarChar,   objReqOrderTransSaleUpd.SaleSeqNos,      8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strProcTypes",     DBType.adVarChar,   objReqOrderTransSaleUpd.ProcTypes,       8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxKinds",      DBType.adVarChar,   objReqOrderTransSaleUpd.TaxKinds,        8000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strItemCodes",     DBType.adVarChar,   objReqOrderTransSaleUpd.ItemCodes,       8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSupplyAmts",    DBType.adVarChar,   objReqOrderTransSaleUpd.SupplyAmts,      8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTaxAmts",       DBType.adVarChar,   objReqOrderTransSaleUpd.TaxAmts,         8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,   objReqOrderTransSaleUpd.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",     DBType.adVarWChar,  objReqOrderTransSaleUpd.AdminName,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_TRANS_SALE_TX_UPD");

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
                                     , 9101, "System error(SetOrderTransSaleUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderTransSaleUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 수출입 오더 위수탁 정보 조회
        /// </summary>
        /// <param name="objReqInoutOrderContract"></param>
        /// <returns></returns>
        public ServiceResult<ResInoutOrderContract> GetInoutOrderContract(ReqInoutOrderContract objReqInoutOrderContract)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetInoutOrderContract REQ] {JsonConvert.SerializeObject(objReqInoutOrderContract)}", bLogWrite);

            ServiceResult<ResInoutOrderContract> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResInoutOrderContract>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqInoutOrderContract.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objReqInoutOrderContract.OrderNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqInoutOrderContract.AdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intContractType",           DBType.adTinyInt,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strContractInfo",           DBType.adVarWChar,  DBNull.Value,                           200,     ParameterDirection.Output);
                                                                                                                                
                lo_objDas.AddParam("@po_intContractCenterCode",     DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractOrderNo",        DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractDispatchSeqNo",  DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intContractStatus",         DBType.adTinyInt,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                                                                                                                                
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_INOUT_CONTRACT_NT_GET");

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

                lo_objResult.data = new ResInoutOrderContract
                {
                    ContractType          = lo_objDas.GetParam("@po_intContractType").ToInt(),
                    ContractInfo          = lo_objDas.GetParam("@po_strContractInfo"),
                    ContractCenterCode    = lo_objDas.GetParam("@po_intContractCenterCode").ToInt(),
                    ContractOrderNo       = lo_objDas.GetParam("@po_intContractOrderNo"),
                    ContractDispatchSeqNo = lo_objDas.GetParam("@po_intContractDispatchSeqNo"),
                    ContractStatus        = lo_objDas.GetParam("@po_intContractStatus").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetInoutOrderContract)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetInoutOrderContract RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 이관 비용 목록
        /// </summary>
        /// <param name="objReqOrderTransPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayList> GetOrderTransPayList(int intCenterCode, Int64 intOrderNo, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderTransPayList REQ] {intCenterCode} | {intOrderNo} | {strAccessCenterCode}", bLogWrite);
            
            string                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderPayList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   intCenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   strAccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_TRANS_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayList
                {
                    list      = new List<OrderPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderTransPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderTransPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 요율표 조회(적용후)
        /// </summary>
        /// <param name="objReqTransRateOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResTransRateOrderList> GetTransRateOrderList(ReqTransRateOrderList objReqTransRateOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetTransRateOrderList REQ] {JsonConvert.SerializeObject(objReqTransRateOrderList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResTransRateOrderList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                
                lo_objResult = new ServiceResult<ResTransRateOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqTransRateOrderList.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objReqTransRateOrderList.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",           DBType.adChar,      objReqTransRateOrderList.CarFixedFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqTransRateOrderList.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",             DBType.adBigInt,    DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateOrderList
                {
                    list       = new List<TransRateOrderModel>(),
                    RecordCnt  = lo_objDas.RecordCount,
                    ApplySeqNo = lo_objDas.GetParam("@po_intApplySeqNo").ToString()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateOrderModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetTransRateOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetTransRateOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 요율표 조회
        /// </summary>
        /// <param name="objReqTransRateOrderApplyList"></param>
        /// <returns></returns>
        public ServiceResult<ResTransRateOrderApplyList> GetTransRateOrderApplyList(ReqTransRateOrderApplyList objReqTransRateOrderApplyList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetTransRateOrderApplyList REQ] {JsonConvert.SerializeObject(objReqTransRateOrderApplyList)}", bLogWrite);
            
            string                                    lo_strJson   = string.Empty;
            ServiceResult<ResTransRateOrderApplyList> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateOrderApplyList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqTransRateOrderApplyList.CenterCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",             DBType.adBigInt,    objReqTransRateOrderApplyList.ClientCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",          DBType.adBigInt,    objReqTransRateOrderApplyList.ConsignorCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",          DBType.adVarChar,   objReqTransRateOrderApplyList.OrderItemCode,            5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",      DBType.adVarChar,   objReqTransRateOrderApplyList.OrderLocationCode,        5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFTLFlag",                DBType.adChar,      objReqTransRateOrderApplyList.FTLFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",           DBType.adChar,      objReqTransRateOrderApplyList.CarFixedFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromAddrs",              DBType.adVarWChar,  objReqTransRateOrderApplyList.FromAddrs,                4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToAddrs",                DBType.adVarWChar,  objReqTransRateOrderApplyList.ToAddrs,                  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",           DBType.adTinyInt,   objReqTransRateOrderApplyList.GoodsRunType,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",             DBType.adVarChar,   objReqTransRateOrderApplyList.CarTonCode,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",            DBType.adVarChar,   objReqTransRateOrderApplyList.CarTypeCode,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",              DBType.adVarChar,   objReqTransRateOrderApplyList.PickupYMD,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",               DBType.adVarChar,   objReqTransRateOrderApplyList.PickupHM,                 4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                 DBType.adVarChar,   objReqTransRateOrderApplyList.GetYMD,                   8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetHM",                  DBType.adVarChar,   objReqTransRateOrderApplyList.GetHM,                    4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                 DBType.adInteger,   objReqTransRateOrderApplyList.Volume,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                    DBType.adDouble,    objReqTransRateOrderApplyList.CBM,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                 DBType.adDouble,    objReqTransRateOrderApplyList.Weight,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                 DBType.adInteger,   objReqTransRateOrderApplyList.Length,                   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strLayoverFlag",            DBType.adChar,      objReqTransRateOrderApplyList.LayoverFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSamePlaceCount",         DBType.adInteger,   objReqTransRateOrderApplyList.SamePlaceCount,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNonSamePlaceCount",      DBType.adInteger,   objReqTransRateOrderApplyList.NonSamePlaceCount,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqTransRateOrderApplyList.AdminID,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",             DBType.adBigInt,    DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_ORDER_APPLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateOrderApplyList
                {
                    list       = new List<TransRateOrderModel>(),
                    RecordCnt  = lo_objDas.RecordCount,
                    ApplySeqNo = lo_objDas.GetParam("@po_intApplySeqNo").ToString()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateOrderModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetTransRateOrderApplyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetTransRateOrderApplyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 고객사 비용 리스트(비용항목)
        /// </summary>
        /// <param name="objReqOrderPayStatementPayItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayStatementPayItemList> GetOrderClientStatementPayItemList(ReqOrderPayStatementPayItemList objReqOrderPayStatementPayItemList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderClientStatementPayItemList REQ] {JsonConvert.SerializeObject(objReqOrderPayStatementPayItemList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResOrderPayStatementPayItemList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayStatementPayItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos", DBType.adVarChar, objReqOrderPayStatementPayItemList.OrderNos, 8000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqOrderPayStatementPayItemList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType", DBType.adTinyInt, objReqOrderPayStatementPayItemList.ListType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType", DBType.adTinyInt, objReqOrderPayStatementPayItemList.DateType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom", DBType.adVarChar, objReqOrderPayStatementPayItemList.DateFrom, 8, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo", DBType.adVarChar, objReqOrderPayStatementPayItemList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes", DBType.adVarChar, objReqOrderPayStatementPayItemList.OrderLocationCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqOrderPayStatementPayItemList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName", DBType.adVarWChar, objReqOrderPayStatementPayItemList.OrderClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode", DBType.adBigInt, objReqOrderPayStatementPayItemList.PayClientCode, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientName", DBType.adVarWChar, objReqOrderPayStatementPayItemList.PayClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName", DBType.adVarWChar, objReqOrderPayStatementPayItemList.ConsignorName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName", DBType.adVarWChar, objReqOrderPayStatementPayItemList.PayClientChargeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqOrderPayStatementPayItemList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_UPS_STATEMENT_PAY_ITEM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayStatementPayItemList
                {
                    list = new List<OrderPayStatementPayItemGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayStatementPayItemGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9201, "System error(GetOrderClientStatementPayItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderClientStatementPayItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 리스트
        /// </summary>
        /// <param name="objReqOrderPayStatementList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayStatementList> GetOrderClientStatementList(ReqOrderPayStatementList objReqOrderPayStatementList, List<OrderPayStatementPayItemGridModel> objPayItemList = null, int intType = 1)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderClientStatementList REQ] {JsonConvert.SerializeObject(objReqOrderPayStatementList)}", bLogWrite);

            string                                  lo_strJson       = string.Empty;
            ServiceResult<ResOrderPayStatementList> lo_objResult     = null;
            IDasNetCom                              lo_objDas        = null;
            DataTable                               lo_objDataTable  = null;
            string                                  lo_strColumnName = string.Empty;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayStatementList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos",              DBType.adVarChar,   objReqOrderPayStatementList.OrderNos,               8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqOrderPayStatementList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",              DBType.adTinyInt,   objReqOrderPayStatementList.ListType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",              DBType.adTinyInt,   objReqOrderPayStatementList.DateType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",              DBType.adVarChar,   objReqOrderPayStatementList.DateFrom,               8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",                DBType.adVarChar,   objReqOrderPayStatementList.DateTo,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",    DBType.adVarChar,   objReqOrderPayStatementList.OrderLocationCodes,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",        DBType.adVarChar,   objReqOrderPayStatementList.OrderItemCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",       DBType.adVarWChar,  objReqOrderPayStatementList.OrderClientName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",         DBType.adBigInt,    objReqOrderPayStatementList.PayClientCode,          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientName",         DBType.adVarWChar,  objReqOrderPayStatementList.PayClientName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",         DBType.adVarWChar,  objReqOrderPayStatementList.ConsignorName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",   DBType.adVarWChar,  objReqOrderPayStatementList.PayClientChargeName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,   objReqOrderPayStatementList.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalSupplyAmt",        DBType.adCurrency,  DBNull.Value,                                       0,       ParameterDirection.Output);
                                                                                                                                           
                lo_objDas.AddParam("@po_intTotalArrivalSupplyAmt", DBType.adCurrency,  DBNull.Value,                                       0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTotalTaxAmt",           DBType.adCurrency,  DBNull.Value,                                       0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTotalOrgAmt",           DBType.adCurrency,  DBNull.Value,                                       0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRecordCnt",             DBType.adInteger,   DBNull.Value,                                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_UPS_STATEMENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayStatementList
                {
                    list                  = new List<OrderPayStatementGridModel>(),
                    RecordCnt             = lo_objDas.GetParam("@po_intRecordCnt").ToInt(),
                    TotalSupplyAmt        = lo_objDas.GetParam("@po_intTotalSupplyAmt").ToDouble(),
                    TotalArrivalSupplyAmt = lo_objDas.GetParam("@po_intTotalArrivalSupplyAmt").ToDouble(),
                    TotalTaxAmt           = lo_objDas.GetParam("@po_intTotalTaxAmt").ToDouble(),
                    TotalOrgAmt           = lo_objDas.GetParam("@po_intTotalOrgAmt").ToDouble()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDataTable = lo_objDas.objDT.Rows[0].Table;
                    SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderClientStatementList REQ] {JsonConvert.SerializeObject(lo_objDataTable)}", bLogWrite);
                    
                    if (objPayItemList != null)
                    {
                        for (int i = 1; i <= 200; i++)
                        {
                            lo_strColumnName = "OP";
                            if (i < 10)
                            {
                                lo_strColumnName += "00" + i;
                            }
                            else if (i < 100)
                            {
                                lo_strColumnName += "0" + i;
                            }
                            else
                            {
                                lo_strColumnName += i;
                            }

                            if (!lo_objDataTable.Columns.Contains(lo_strColumnName))
                            {
                                lo_objDataTable.Columns.Add(lo_strColumnName, typeof(double));
                            }
                        }

                        foreach (DataRow row in lo_objDataTable.Rows)
                        {
                            for (int i = 1; i <= 200; i++)
                            {
                                lo_strColumnName = "OP";
                                if (i < 10)
                                {
                                    lo_strColumnName += "00" + i;
                                }
                                else if (i < 100)
                                {
                                    lo_strColumnName += "0" + i;
                                }
                                else
                                {
                                    lo_strColumnName += i;
                                }

                                row[lo_strColumnName] = 0;
                            }
                        }

                        foreach (DataRow row in lo_objDataTable.Rows)
                        {
                            foreach (var subRow in objPayItemList.FindAll(r => r.CenterCode.ToString().Equals(row["CenterCode"].ToString())).FindAll(r => r.OrderNo.ToString().Equals(row["OrderNo"].ToString())).FindAll(r => r.GoodsSeqNo.ToString().Equals(row["GoodsSeqNo"].ToString())))
                            {
                                row[subRow.ItemCode] = subRow.SupplyAmt;
                            }
                        }
                    }

                    lo_strJson = JsonConvert.SerializeObject(lo_objDataTable);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayStatementGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9202, "System error(GetOrderClientStatementList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderClientStatementList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 화승 엑셀 오더 체크
        /// </summary>
        /// <param name="objReqOrderHwaseungChk"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderHwaseungChk> GetOrderHwaseungChk(ReqOrderHwaseungChk objReqOrderHwaseungChk)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderHwaseungChk REQ] {JsonConvert.SerializeObject(objReqOrderHwaseungChk)}", bLogWrite);

            string                             lo_strJson       = string.Empty;
            ServiceResult<ResOrderHwaseungChk> lo_objResult     = null;
            IDasNetCom                         lo_objDas        = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderHwaseungChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqOrderHwaseungChk.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objReqOrderHwaseungChk.ConsignorName,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryType",        DBType.adVarWChar,  objReqOrderHwaseungChk.DeliveryType,     50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",           DBType.adVarChar,   objReqOrderHwaseungChk.PickupYMD,        8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",         DBType.adVarWChar,  objReqOrderHwaseungChk.PickupPlace,      200,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlace",            DBType.adVarWChar,  objReqOrderHwaseungChk.GetPlace,         200,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",              DBType.adVarWChar,  objReqOrderHwaseungChk.CarTon,           50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",               DBType.adVarWChar,  objReqOrderHwaseungChk.CarNo,            50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",          DBType.adVarWChar,  objReqOrderHwaseungChk.DriverName,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",          DBType.adVarChar,   objReqOrderHwaseungChk.DriverCell,       20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intRefSeqNo",            DBType.adBigInt,    objReqOrderHwaseungChk.RefSeqNo,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objReqOrderHwaseungChk.AdminID,          50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strCenterFlag",          DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCenterCode",          DBType.adInteger,   DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAuthFlag",            DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strClientFlag",          DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intClientCode",          DBType.adBigInt,    DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPickupYMDFlag",       DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strConsignorFlag",       DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intConsignorCode",       DBType.adBigInt,    DBNull.Value,                            0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strPickupPlaceFlag",     DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intPickupPlaceSeqNo",    DBType.adBigInt,    DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strGetPlaceFlag",        DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGetPlaceSeqNo",       DBType.adBigInt,    DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarTonFlag",          DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strCarTonCode",          DBType.adVarChar,   DBNull.Value,                            5,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarFlag",             DBType.adChar,      DBNull.Value,                            1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarCnt",              DBType.adInteger,   DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRefSeqNo",            DBType.adBigInt,    DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                            256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                            0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                            256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                            0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_HWASEUNG_NT_CHK");

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

                lo_objResult.data = new ResOrderHwaseungChk
                {
                    CenterFlag       = lo_objDas.GetParam("@po_strCenterFlag"),
                    CenterCode       = lo_objDas.GetParam("@po_intCenterCode").ToInt(),
                    AuthFlag         = lo_objDas.GetParam("@po_strAuthFlag"),
                    ClientFlag       = lo_objDas.GetParam("@po_strClientFlag"),
                    ClientCode       = lo_objDas.GetParam("@po_intClientCode"),
                    ConsignorFlag    = lo_objDas.GetParam("@po_strConsignorFlag"),
                    ConsignorCode    = lo_objDas.GetParam("@po_intConsignorCode"),
                    PickupYMDFlag    = lo_objDas.GetParam("@po_strPickupYMDFlag"),
                    PickupPlaceFlag  = lo_objDas.GetParam("@po_strPickupPlaceFlag"),
                    PickupPlaceSeqNo = lo_objDas.GetParam("@po_intPickupPlaceSeqNo"),
                    GetPlaceFlag     = lo_objDas.GetParam("@po_strGetPlaceFlag"),
                    GetPlaceSeqNo    = lo_objDas.GetParam("@po_intGetPlaceSeqNo"),
                    CarTonFlag       = lo_objDas.GetParam("@po_strCarTonFlag"),
                    CarTonCode       = lo_objDas.GetParam("@po_strCarTonCode"),
                    CarFlag          = lo_objDas.GetParam("@po_strCarFlag"),
                    CarCnt           = lo_objDas.GetParam("@po_intCarCnt").ToInt(),
                    RefSeqNo         = lo_objDas.GetParam("@po_intRefSeqNo")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9202, "System error(GetOrderHwaseungChk)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetOrderHwaseungChk RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 화승 엑셀 오더 등록
        /// </summary>
        /// <param name="objReqOrderHwaseungIns"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderHwaseungIns> SetOrderHwaseungIns(ReqOrderHwaseungIns objReqOrderHwaseungIns)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderHwaseungIns REQ] {JsonConvert.SerializeObject(objReqOrderHwaseungIns)}", bLogWrite);

            ServiceResult<ResOrderHwaseungIns> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderHwaseungIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",                  DBType.adInteger,   objReqOrderHwaseungIns.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",             DBType.adBigInt,    objReqOrderHwaseungIns.OrderClientCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",               DBType.adBigInt,    objReqOrderHwaseungIns.PayClientCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",               DBType.adBigInt,    objReqOrderHwaseungIns.ConsignorCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryType",                DBType.adVarWChar,  objReqOrderHwaseungIns.DeliveryType,              50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupYMD",                   DBType.adVarChar,   objReqOrderHwaseungIns.PickupYMD,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPickupPlaceSeqNo",            DBType.adBigInt,    objReqOrderHwaseungIns.PickupPlaceSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                      DBType.adVarChar,   objReqOrderHwaseungIns.GetYMD,                    8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGetPlaceSeqNo",               DBType.adBigInt,    objReqOrderHwaseungIns.GetPlaceSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteInside",                  DBType.adVarWChar,  objReqOrderHwaseungIns.NoteInside,                1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",                  DBType.adVarChar,   objReqOrderHwaseungIns.CarTonCode,                5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",                    DBType.adBigInt,    objReqOrderHwaseungIns.RefSeqNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleAmt",                     DBType.adCurrency,  objReqOrderHwaseungIns.SaleAmt,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleLayoverAmt",              DBType.adCurrency,  objReqOrderHwaseungIns.SaleLayoverAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleWaitingAmt",              DBType.adCurrency,  objReqOrderHwaseungIns.SaleWaitingAmt,            0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intSaleWorkingAmt",              DBType.adCurrency,  objReqOrderHwaseungIns.SaleWorkingAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleAreaAmt",                 DBType.adCurrency,  objReqOrderHwaseungIns.SaleAreaAmt,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleOilDifferenceAmt",        DBType.adCurrency,  objReqOrderHwaseungIns.SaleOilDifferenceAmt,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseAmt",                 DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseAmt,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseLayoverAmt",          DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseLayoverAmt,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseWaitingAmt",          DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseWaitingAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseConservationAmt",     DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseConservationAmt,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseOilAmt",              DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseOilAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseAreaAmt",             DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseAreaAmt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseOilDifferenceAmt",    DBType.adCurrency,  objReqOrderHwaseungIns.PurchaseOilDifferenceAmt,  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",                  DBType.adVarChar,   objReqOrderHwaseungIns.RegAdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",                DBType.adVarWChar,  objReqOrderHwaseungIns.RegAdminName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intOrderNo",                     DBType.adBigInt,    DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAddSeqNo",                    DBType.adBigInt,    DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGoodsSeqNo",                  DBType.adBigInt,    DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDispatchSeqNo",               DBType.adBigInt,    DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                      DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                      DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                    DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                    DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_HWASEUNG_TX_INS");
                
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
                lo_objResult.data = new ResOrderHwaseungIns
                {
                    OrderNo       = lo_objDas.GetParam("@po_intOrderNo"),
                    AddSeqNo      = lo_objDas.GetParam("@po_intAddSeqNo"),
                    GoodsSeqNo    = lo_objDas.GetParam("@po_intGoodsSeqNo"),
                    DispatchSeqNo = lo_objDas.GetParam("@po_intDispatchSeqNo")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderHwaseungIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderHwaseungIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 오더 PDF 파싱 로그 등록
        /// </summary>
        /// <param name="objOrderPdfLogModel"></param>
        /// <returns></returns>
        public ServiceResult<OrderPdfLogModel> SetOrderPdfLogIns(OrderPdfLogModel objOrderPdfLogModel)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPdfLogIns REQ] {JsonConvert.SerializeObject(objOrderPdfLogModel)}", bLogWrite);

            ServiceResult<OrderPdfLogModel> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderPdfLogModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strFileName",       DBType.adVarWChar,  objOrderPdfLogModel.FileName,      200,                                    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFileUrl",        DBType.adVarChar,   objOrderPdfLogModel.FileUrl,       1000,                                   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRawData",        DBType.adVarWChar,  objOrderPdfLogModel.RawData,       objOrderPdfLogModel.RawData.Length,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strViewData",       DBType.adVarWChar,  objOrderPdfLogModel.ViewData,      4000,                                   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRegType",        DBType.adTinyInt,   objOrderPdfLogModel.RegType,       0,                                      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objOrderPdfLogModel.RegAdminID,    50,                                     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objOrderPdfLogModel.RegAdminName,  50,                                     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",          DBType.adBigInt,    DBNull.Value,                      0,                                      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,                                    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                      0,                                      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,                                    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                      0,                                      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PDF_LOG_TX_INS");

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
                objOrderPdfLogModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt64();
                lo_objResult.data         = objOrderPdfLogModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetOrderPdfLogIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderPdfLogIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// EDI 오더 목록
        /// </summary>
        /// <param name="objReqEdiWorkOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResEdiWorkOrderList> GetEdiWorkOrderList(ReqEdiWorkOrderList objReqEdiWorkOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiWorkOrderList REQ] {JsonConvert.SerializeObject(objReqEdiWorkOrderList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResEdiWorkOrderList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResEdiWorkOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intWoSeqNo",                   DBType.adBigInt,    objReqEdiWorkOrderList.WoSeqNo,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWorkOrderNumber",           DBType.adVarChar,   objReqEdiWorkOrderList.WorkOrderNumber,            30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                   DBType.adBigInt,    objReqEdiWorkOrderList.OrderNo,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objReqEdiWorkOrderList.CenterCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                  DBType.adTinyInt,   objReqEdiWorkOrderList.DateType,                   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateFrom",                  DBType.adVarChar,   objReqEdiWorkOrderList.DateFrom,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                    DBType.adVarChar,   objReqEdiWorkOrderList.DateTo,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWorkOrderStatuses",         DBType.adVarChar,   objReqEdiWorkOrderList.WorkOrderStatuses,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCreatedBy",                 DBType.adVarChar,   objReqEdiWorkOrderList.CreatedBy,                  30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMasterAirWayBillNumber",    DBType.adVarChar,   objReqEdiWorkOrderList.MasterAirWayBillNumber,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strHouseAirWayBillNumber",     DBType.adVarChar,   objReqEdiWorkOrderList.HouseAirWayBillNumber,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",               DBType.adChar,      objReqEdiWorkOrderList.MyOrderFlag,                1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                   DBType.adVarChar,   objReqEdiWorkOrderList.AdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",          DBType.adVarChar,   objReqEdiWorkOrderList.AccessCenterCode,           512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                  DBType.adInteger,   objReqEdiWorkOrderList.PageSize,                   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",                    DBType.adInteger,   objReqEdiWorkOrderList.PageNo,                     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",                 DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_EDI_WORKORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResEdiWorkOrderList
                {
                    list      = new List<EdiWorkOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<EdiWorkOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetEdiWorkOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiWorkOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// EDI 상하차지 목록
        /// </summary>
        /// <param name="objReqEdiStopList"></param>
        /// <returns></returns>
        public ServiceResult<ResEdiStopList> GetEdiStopList(ReqEdiStopList objReqEdiStopList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiStopList REQ] {JsonConvert.SerializeObject(objReqEdiStopList)}", bLogWrite);

            string                        lo_strJson   = string.Empty;
            ServiceResult<ResEdiStopList> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResEdiStopList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intStSeqNo",              DBType.adBigInt,    objReqEdiStopList.StSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWorkOrderNumber",      DBType.adVarChar,   objReqEdiStopList.WorkOrderNumber,     30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqEdiStopList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqEdiStopList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStopType",             DBType.adVarChar,   objReqEdiStopList.StopType,            15,      ParameterDirection.Input);
                                                                                                                             
                lo_objDas.AddParam("@pi_strStopName",             DBType.adVarChar,   objReqEdiStopList.StopName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqEdiStopList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_EDI_STOP_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResEdiStopList
                {
                    list      = new List<EdiStopGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<EdiStopGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetEdiStopList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiStopList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// EDI 화물 목록
        /// </summary>
        /// <param name="objReqEdiEquipmentList"></param>
        /// <returns></returns>
        public ServiceResult<ResEdiEquipmentList> GetEdiEquipmentList(ReqEdiEquipmentList objReqEdiEquipmentList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiEquipmentList REQ] {JsonConvert.SerializeObject(objReqEdiEquipmentList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResEdiEquipmentList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResEdiEquipmentList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intEqSeqNo",              DBType.adBigInt,    objReqEdiEquipmentList.EqSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWorkOrderNumber",      DBType.adVarChar,   objReqEdiEquipmentList.WorkOrderNumber,     30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqEdiEquipmentList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqEdiEquipmentList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqEdiEquipmentList.AccessCenterCode,    512,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_EDI_EQUIPMENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResEdiEquipmentList
                {
                    list      = new List<EdiEquipmentGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<EdiEquipmentGridModel>>(lo_strJson);
                    }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetEdiEquipmentList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetEdiEquipmentList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// EDI 오더 상태 업데이트
        /// </summary>
        /// <param name="objReqEdiWorkOrderProcState"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetEdiWorkOrderProcStateUpd(ReqEdiWorkOrderProcStateUpd objReqEdiWorkOrderProcState)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetEdiWorkOrderProcStateUpd REQ] {JsonConvert.SerializeObject(objReqEdiWorkOrderProcState)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqEdiWorkOrderProcState.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqEdiWorkOrderProcState.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intProcType",            DBType.adTinyInt,   objReqEdiWorkOrderProcState.ProcType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPODUrl",              DBType.adVarChar,   objReqEdiWorkOrderProcState.PODUrl,               512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRejectReasonCode",    DBType.adVarChar,   objReqEdiWorkOrderProcState.RejectReasonCode,     10,      ParameterDirection.Input);
                                                                                                               
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objReqEdiWorkOrderProcState.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_EDI_WORKORDER_PROC_STATE_TX_UPD");

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
                                     , 9101, "System error(SetEdiWorkOrderProcStateUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetEdiWorkOrderProcStateUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 배송오더현황
        /// </summary>
        /// <param name="objReqWmsOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResWmsOrderList> GetWmsOrderList(ReqWmsOrderList objReqWmsOrderList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderList REQ] {JsonConvert.SerializeObject(objReqWmsOrderList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<ResWmsOrderList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResWmsOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqWmsOrderList.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqWmsOrderList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqWmsOrderList.DateFrom,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqWmsOrderList.DateTo,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderStatuses",        DBType.adVarChar,   objReqWmsOrderList.OrderStatuses,        4000,    ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strOrderClientName",      DBType.adVarWChar,  objReqWmsOrderList.OrderClientName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",        DBType.adVarWChar,  objReqWmsOrderList.PayClientName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",        DBType.adVarWChar,  objReqWmsOrderList.ConsignorName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",          DBType.adVarWChar,  objReqWmsOrderList.PickupPlace,          200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",              DBType.adVarWChar,  objReqWmsOrderList.ComName,              50,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strComCorpNo",            DBType.adVarChar,   objReqWmsOrderList.ComCorpNo,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",           DBType.adVarWChar,  objReqWmsOrderList.DriverName,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                DBType.adVarWChar,  objReqWmsOrderList.CarNo,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryNo",           DBType.adVarChar,   objReqWmsOrderList.DeliveryNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",      DBType.adVarWChar,  objReqWmsOrderList.AcceptAdminName,      50,      ParameterDirection.Input);
                                                                      
                lo_objDas.AddParam("@pi_strMyOrderFlag",          DBType.adChar,      objReqWmsOrderList.MyOrderFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",              DBType.adChar,      objReqWmsOrderList.CnlFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objReqWmsOrderList.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqWmsOrderList.AccessCenterCode,     512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqWmsOrderList.PageSize,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqWmsOrderList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_WMS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResWmsOrderList
                {
                    list      = new List<WmsOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WmsOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWmsOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 배송오더 배송지현황
        /// </summary>
        /// <param name="objReqWmsOrderLayoverList"></param>
        /// <returns></returns>
        public ServiceResult<ResWmsOrderLayoverList> GetWmsOrderLayoverList(ReqWmsOrderLayoverList objReqWmsOrderLayoverList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverList REQ] {JsonConvert.SerializeObject(objReqWmsOrderLayoverList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResWmsOrderLayoverList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResWmsOrderLayoverList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intLayoverSeqNo",         DBType.adBigInt,    objReqWmsOrderLayoverList.LayoverSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqWmsOrderLayoverList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqWmsOrderLayoverList.OrderNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryNo",           DBType.adVarChar,   objReqWmsOrderLayoverList.DeliveryNo,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqWmsOrderLayoverList.AccessCenterCode,      512,     ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqWmsOrderLayoverList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqWmsOrderLayoverList.PageNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_LAYOVER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResWmsOrderLayoverList
                {
                    list      = new List<WmsOrderLayoverGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WmsOrderLayoverGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWmsOrderLayoverList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배송오더 배송지 증빙목록
        /// </summary>
        /// <param name="objReqWmsOrderLayoverFileList"></param>
        /// <returns></returns>
        public ServiceResult<ResWmsOrderLayoverFileList> GetWmsOrderLayoverFileList(ReqWmsOrderLayoverFileList objReqWmsOrderLayoverFileList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverFileList REQ] {JsonConvert.SerializeObject(objReqWmsOrderLayoverFileList)}", bLogWrite);

            string                                    lo_strJson   = string.Empty;
            ServiceResult<ResWmsOrderLayoverFileList> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResWmsOrderLayoverFileList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intFileSeqNo",            DBType.adBigInt,    objReqWmsOrderLayoverFileList.FileSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqWmsOrderLayoverFileList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqWmsOrderLayoverFileList.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryNo",           DBType.adVarChar,   objReqWmsOrderLayoverFileList.DeliveryNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFileType",             DBType.adTinyInt,   objReqWmsOrderLayoverFileList.FileType,             0,       ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_intFileGubun",            DBType.adTinyInt,   objReqWmsOrderLayoverFileList.FileGubun,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",              DBType.adChar,      objReqWmsOrderLayoverFileList.DelFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqWmsOrderLayoverFileList.AccessCenterCode,     512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqWmsOrderLayoverFileList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqWmsOrderLayoverFileList.PageNo,               0,       ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_LAYOVER_FILE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResWmsOrderLayoverFileList
                {
                    list      = new List<WmsOrderLayoverFileGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WmsOrderLayoverFileGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWmsOrderLayoverFileList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverFileList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배송오더 배송지 화물목록
        /// </summary>
        /// <param name="objReqWmsOrderLayoverGoodsList"></param>
        /// <returns></returns>
        public ServiceResult<ResWmsOrderLayoverGoodsList> GetWmsOrderLayoverGoodsList(ReqWmsOrderLayoverGoodsList objReqWmsOrderLayoverGoodsList)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverGoodsList REQ] {JsonConvert.SerializeObject(objReqWmsOrderLayoverGoodsList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResWmsOrderLayoverGoodsList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResWmsOrderLayoverGoodsList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGoodsSeqNo",          DBType.adBigInt,    objReqWmsOrderLayoverGoodsList.GoodsSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqWmsOrderLayoverGoodsList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqWmsOrderLayoverGoodsList.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryNo",          DBType.adVarChar,   objReqWmsOrderLayoverGoodsList.DeliveryNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqWmsOrderLayoverGoodsList.AccessCenterCode,     512,     ParameterDirection.Input);
                                                                 
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objReqWmsOrderLayoverGoodsList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objReqWmsOrderLayoverGoodsList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_LAYOVER_GOODS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResWmsOrderLayoverGoodsList
                {
                    list      = new List<WmsOrderLayoverGoodsGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WmsOrderLayoverGoodsGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWmsOrderLayoverGoodsList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[GetWmsOrderLayoverGoodsList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배송지 화물 상태 수정
        /// </summary>
        /// <param name="objOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetOrderLayoverGoodsStatusUpd(ReqOrderLayoverGoodsStatusUpd objReqOrderLayoverGoodsStatusUpd)
        {
            SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderLayoverGoodsStatusUpd REQ] {JsonConvert.SerializeObject(objReqOrderLayoverGoodsStatusUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqOrderLayoverGoodsStatusUpd.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    objReqOrderLayoverGoodsStatusUpd.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",    DBType.adBigInt,    objReqOrderLayoverGoodsStatusUpd.GoodsSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intStatusType",    DBType.adTinyInt,   objReqOrderLayoverGoodsStatusUpd.StatusType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intStatusValue",   DBType.adTinyInt,   objReqOrderLayoverGoodsStatusUpd.StatusValue,     0,       ParameterDirection.Input);
                                                           
                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,   objReqOrderLayoverGoodsStatusUpd.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_LAYOVER_GOODS_STATUS_TX_UPD");
                
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
                                     , 9101, "System error(SetOrderLayoverGoodsStatusUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDasServices", "I", $"[SetOrderLayoverGoodsStatusUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}