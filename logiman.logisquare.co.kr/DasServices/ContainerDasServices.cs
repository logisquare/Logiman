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
    public class ContainerDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 컨테이너 오더 등록
        /// </summary>
        /// <param name="objContainerModel"></param>
        /// <returns></returns>
        public ServiceResult<ContainerModel> SetContainerIns(ContainerModel objContainerModel)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerIns REQ] {JsonConvert.SerializeObject(objContainerModel)}", bLogWrite);

            ServiceResult<ContainerModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ContainerModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objContainerModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objContainerModel.OrderItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",              DBType.adVarChar,   objContainerModel.OrderLocationCode,             5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objContainerModel.OrderClientCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objContainerModel.OrderClientName,               50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objContainerModel.OrderClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargePosition",      DBType.adVarWChar,  objContainerModel.OrderClientChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelExtNo",      DBType.adVarChar,   objContainerModel.OrderClientChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelNo",         DBType.adVarChar,   objContainerModel.OrderClientChargeTelNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeCell",          DBType.adVarChar,   objContainerModel.OrderClientChargeCell,         20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objContainerModel.PayClientCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objContainerModel.PayClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargePosition",        DBType.adVarWChar,  objContainerModel.PayClientChargePosition,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objContainerModel.PayClientChargeName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeTelExtNo",        DBType.adVarChar,   objContainerModel.PayClientChargeTelExtNo,       20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeTelNo",           DBType.adVarChar,   objContainerModel.PayClientChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeCell",            DBType.adVarChar,   objContainerModel.PayClientChargeCell,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objContainerModel.PayClientChargeLocation,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",                  DBType.adBigInt,    objContainerModel.ConsignorCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objContainerModel.ConsignorName,                 50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objContainerModel.PickupYMD,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objContainerModel.PickupHM,                      4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objContainerModel.PickupPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objContainerModel.PickupPlacePost,               6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objContainerModel.PickupPlaceAddr,               100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objContainerModel.PickupPlaceAddrDtl,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objContainerModel.PickupPlaceFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objContainerModel.PickupPlaceChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objContainerModel.PickupPlaceChargeTelNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objContainerModel.PickupPlaceChargeCell,         20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objContainerModel.PickupPlaceChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objContainerModel.PickupPlaceChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",           DBType.adVarChar,   objContainerModel.PickupPlaceLocalCode,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",           DBType.adVarWChar,  objContainerModel.PickupPlaceLocalName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objContainerModel.PickupPlaceNote,               300,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objContainerModel.NoteClient,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteInside",                     DBType.adVarWChar,  objContainerModel.NoteInside,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustomFlag",                     DBType.adChar,      objContainerModel.CustomFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objContainerModel.BondedFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDocumentFlag",                   DBType.adChar,      objContainerModel.DocumentFlag,                  1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOrderStatus",                    DBType.adTinyInt,   objContainerModel.OrderStatus,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderRegType",                   DBType.adTinyInt,   objContainerModel.OrderRegType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItem",                           DBType.adVarWChar,  objContainerModel.Item,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPort",                           DBType.adVarWChar,  objContainerModel.Port,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCargoClosingTime",               DBType.adVarWChar,  objContainerModel.CargoClosingTime,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strEnterYMD",                       DBType.adVarChar,   objContainerModel.EnterYMD,                      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipmentYMD",                    DBType.adVarChar,   objContainerModel.ShipmentYMD,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipmentPort",                   DBType.adVarWChar,  objContainerModel.ShipmentPort,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingCompany",                DBType.adVarWChar,  objContainerModel.ShippingCompany,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingShipName",               DBType.adVarWChar,  objContainerModel.ShippingShipName,              50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShippingCharge",                 DBType.adVarWChar,  objContainerModel.ShippingCharge,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingTelNo",                  DBType.adVarChar,   objContainerModel.ShippingTelNo,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCY",                       DBType.adVarWChar,  objContainerModel.PickupCY,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCYCharge",                 DBType.adVarWChar,  objContainerModel.PickupCYCharge,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCYTelNo",                  DBType.adVarChar,   objContainerModel.PickupCYTelNo,                 20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetCY",                          DBType.adVarWChar,  objContainerModel.GetCY,                         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetCYCharge",                    DBType.adVarWChar,  objContainerModel.GetCYCharge,                   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetCYTelNo",                     DBType.adVarChar,   objContainerModel.GetCYTelNo,                    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignor",                      DBType.adVarWChar,  objContainerModel.Consignor,                     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipCode",                       DBType.adVarChar,   objContainerModel.ShipCode,                      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShipName",                       DBType.adVarWChar,  objContainerModel.ShipName,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDivCode",                        DBType.adVarWChar,  objContainerModel.DivCode,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objContainerModel.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objContainerModel.Volume,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objContainerModel.Weight,                        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objContainerModel.BookingNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCntrNo",                         DBType.adVarChar,   objContainerModel.CntrNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSealNo",                         DBType.adVarChar,   objContainerModel.SealNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDONo",                           DBType.adVarChar,   objContainerModel.DONo,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsOrderNo",                   DBType.adVarChar,   objContainerModel.GoodsOrderNo,                  50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBLNo",                           DBType.adVarChar,   objContainerModel.BLNo,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objContainerModel.GoodsRunType,                  0,       ParameterDirection.Input);// 2023-03-16 by shadow54 : 자동운임 수정 건
                lo_objDas.AddParam("@pi_strCarFixedFlag",                   DBType.adChar,      objContainerModel.CarFixedFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayoverFlag",                    DBType.adChar,      objContainerModel.LayoverFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSamePlaceCount",                 DBType.adInteger,   objContainerModel.SamePlaceCount,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intNonSamePlaceCount",              DBType.adInteger,   objContainerModel.NonSamePlaceCount,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqSeqNo",                       DBType.adBigInt,    objContainerModel.ReqSeqNo,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",                     DBType.adVarChar,   objContainerModel.RegAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",                   DBType.adVarWChar,  objContainerModel.RegAdminName,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intOrderNo",                        DBType.adBigInt,    DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intAddSeqNo",                       DBType.adBigInt,    DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intGoodsSeqNo",                     DBType.adBigInt,    DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_TX_INS");
                
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
                objContainerModel.OrderNo    = lo_objDas.GetParam("@po_intOrderNo").ToInt64();
                objContainerModel.AddSeqNo   = lo_objDas.GetParam("@po_intAddSeqNo").ToInt64();
                objContainerModel.GoodsSeqNo = lo_objDas.GetParam("@po_intGoodsSeqNo").ToInt64();

                lo_objResult.data = objContainerModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetContainerIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더 수정
        /// </summary>
        /// <param name="objContainerModel"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerUpd> SetContainerUpd(ContainerModel objContainerModel)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerUpd REQ] {JsonConvert.SerializeObject(objContainerModel)}", bLogWrite);

            ServiceResult<ResContainerUpd> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objContainerModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                        DBType.adBigInt,    objContainerModel.OrderNo,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objContainerModel.OrderItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",              DBType.adVarChar,   objContainerModel.OrderLocationCode,             5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objContainerModel.OrderClientCode,               0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objContainerModel.OrderClientName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objContainerModel.OrderClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargePosition",      DBType.adVarWChar,  objContainerModel.OrderClientChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelExtNo",      DBType.adVarChar,   objContainerModel.OrderClientChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeTelNo",         DBType.adVarChar,   objContainerModel.OrderClientChargeTelNo,        20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientChargeCell",          DBType.adVarChar,   objContainerModel.OrderClientChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objContainerModel.PayClientCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objContainerModel.PayClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargePosition",        DBType.adVarWChar,  objContainerModel.PayClientChargePosition,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objContainerModel.PayClientChargeName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeTelExtNo",        DBType.adVarChar,   objContainerModel.PayClientChargeTelExtNo,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeTelNo",           DBType.adVarChar,   objContainerModel.PayClientChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeCell",            DBType.adVarChar,   objContainerModel.PayClientChargeCell,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objContainerModel.PayClientChargeLocation,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",                  DBType.adBigInt,    objContainerModel.ConsignorCode,                 0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objContainerModel.ConsignorName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objContainerModel.PickupYMD,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objContainerModel.PickupHM,                      4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objContainerModel.PickupPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objContainerModel.PickupPlacePost,               6,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objContainerModel.PickupPlaceAddr,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objContainerModel.PickupPlaceAddrDtl,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objContainerModel.PickupPlaceFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objContainerModel.PickupPlaceChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objContainerModel.PickupPlaceChargeTelNo,        20,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objContainerModel.PickupPlaceChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objContainerModel.PickupPlaceChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objContainerModel.PickupPlaceChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",           DBType.adVarChar,   objContainerModel.PickupPlaceLocalCode,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",           DBType.adVarWChar,  objContainerModel.PickupPlaceLocalName,          50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objContainerModel.PickupPlaceNote,               300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objContainerModel.NoteClient,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteInside",                     DBType.adVarWChar,  objContainerModel.NoteInside,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustomFlag",                     DBType.adChar,      objContainerModel.CustomFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objContainerModel.BondedFlag,                    1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDocumentFlag",                   DBType.adChar,      objContainerModel.DocumentFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",                     DBType.adBigInt,    objContainerModel.GoodsSeqNo,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItem",                           DBType.adVarWChar,  objContainerModel.Item,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPort",                           DBType.adVarWChar,  objContainerModel.Port,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCargoClosingTime",               DBType.adVarWChar,  objContainerModel.CargoClosingTime,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strEnterYMD",                       DBType.adVarChar,   objContainerModel.EnterYMD,                      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipmentYMD",                    DBType.adVarChar,   objContainerModel.ShipmentYMD,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipmentPort",                   DBType.adVarWChar,  objContainerModel.ShipmentPort,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingCompany",                DBType.adVarWChar,  objContainerModel.ShippingCompany,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingShipName",               DBType.adVarWChar,  objContainerModel.ShippingShipName,              50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShippingCharge",                 DBType.adVarWChar,  objContainerModel.ShippingCharge,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingTelNo",                  DBType.adVarChar,   objContainerModel.ShippingTelNo,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCY",                       DBType.adVarWChar,  objContainerModel.PickupCY,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCYCharge",                 DBType.adVarWChar,  objContainerModel.PickupCYCharge,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupCYTelNo",                  DBType.adVarChar,   objContainerModel.PickupCYTelNo,                 20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetCY",                          DBType.adVarWChar,  objContainerModel.GetCY,                         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetCYCharge",                    DBType.adVarWChar,  objContainerModel.GetCYCharge,                   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetCYTelNo",                     DBType.adVarChar,   objContainerModel.GetCYTelNo,                    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignor",                      DBType.adVarWChar,  objContainerModel.Consignor,                     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipCode",                       DBType.adVarChar,   objContainerModel.ShipCode,                      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShipName",                       DBType.adVarWChar,  objContainerModel.ShipName,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDivCode",                        DBType.adVarWChar,  objContainerModel.DivCode,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objContainerModel.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objContainerModel.Volume,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objContainerModel.Weight,                        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objContainerModel.BookingNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCntrNo",                         DBType.adVarChar,   objContainerModel.CntrNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSealNo",                         DBType.adVarChar,   objContainerModel.SealNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDONo",                           DBType.adVarChar,   objContainerModel.DONo,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsOrderNo",                   DBType.adVarChar,   objContainerModel.GoodsOrderNo,                  50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBLNo",                           DBType.adVarChar,   objContainerModel.BLNo,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objContainerModel.GoodsRunType,                  0,       ParameterDirection.Input);    // 2023-03-16 by shadow54 : 자동운임 수정 건
                lo_objDas.AddParam("@pi_strCarFixedFlag",                   DBType.adChar,      objContainerModel.CarFixedFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayoverFlag",                    DBType.adChar,      objContainerModel.LayoverFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSamePlaceCount",                 DBType.adInteger,   objContainerModel.SamePlaceCount,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intNonSamePlaceCount",              DBType.adInteger,   objContainerModel.NonSamePlaceCount,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",                     DBType.adVarChar,   objContainerModel.UpdAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",                   DBType.adVarWChar,  objContainerModel.UpdAdminName,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strSaleClosingFlag",                DBType.adVarChar,   DBNull.Value,                                    1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPurchaseClosingFlag",            DBType.adVarChar,   DBNull.Value,                                    1,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_TX_UPD");
                
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

                lo_objResult.data = new ResContainerUpd
                {
                    SaleClosingFlag     = lo_objDas.GetParam("@po_strSaleClosingFlag"),
                    PurchaseClosingFlag = lo_objDas.GetParam("@po_strPurchaseClosingFlag")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetContainerUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더
        /// </summary>
        /// <param name="objReqContainerList"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerList> GetContainerList(ReqContainerList objReqContainerList)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerList REQ] {JsonConvert.SerializeObject(objReqContainerList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResContainerList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",                        DBType.adBigInt,    objReqContainerList.OrderNo,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objReqContainerList.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                       DBType.adVarChar,   objReqContainerList.DateFrom,                      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                         DBType.adVarChar,   objReqContainerList.DateTo,                        8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",             DBType.adVarChar,   objReqContainerList.OrderLocationCodes,            4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderItemCodes",                 DBType.adVarChar,   objReqContainerList.OrderItemCodes,                4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objReqContainerList.OrderClientName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objReqContainerList.OrderClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objReqContainerList.PayClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objReqContainerList.PayClientChargeName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objReqContainerList.PayClientChargeLocation,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objReqContainerList.ConsignorName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                        DBType.adVarWChar,  objReqContainerList.ComName,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                          DBType.adVarWChar,  objReqContainerList.CarNo,                         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objReqContainerList.PickupPlace,                   200,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAcceptAdminName",                DBType.adVarWChar,  objReqContainerList.AcceptAdminName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objReqContainerList.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingCompany",                DBType.adVarWChar,  objReqContainerList.ShippingCompany,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCntrNo",                         DBType.adVarChar,   objReqContainerList.CntrNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBLNo",                           DBType.adVarChar,   objReqContainerList.BLNo,                          5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMyChargeFlag",                   DBType.adChar,      objReqContainerList.MyChargeFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",                    DBType.adChar,      objReqContainerList.MyOrderFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                        DBType.adChar,      objReqContainerList.CnlFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSortType",                       DBType.adTinyInt,   objReqContainerList.SortType,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                        DBType.adVarChar,   objReqContainerList.AdminID,                       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",               DBType.adVarChar,   objReqContainerList.AccessCenterCode,              512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                       DBType.adInteger,   objReqContainerList.PageSize,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                         DBType.adInteger,   objReqContainerList.PageNo,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",                      DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResContainerList
                {
                    list      = new List<ContainerGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ContainerGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetContainerList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더 취소
        /// </summary>
        /// <param name="objContainerCnl"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerCnl> SetContainerCnl(ReqContainerCnl objContainerCnl)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerCnl REQ] {JsonConvert.SerializeObject(objContainerCnl)}", bLogWrite);

            ServiceResult<ResContainerCnl> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerCnl>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos",           DBType.adVarChar,   objContainerCnl.OrderNos,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objContainerCnl.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlReason",          DBType.adVarWChar,  objContainerCnl.CnlReason,         500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",         DBType.adVarChar,   objContainerCnl.CnlAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",       DBType.adVarWChar,  objContainerCnl.CnlAdminName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objContainerCnl.AccessCenterCode,  512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,   objContainerCnl.GradeCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",           DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCancelCnt",          DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

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

                lo_objResult.data = new ResContainerCnl
                {
                    TotalCnt  = lo_objDas.GetParam("@po_intTotalCnt").ToInt(),
                    CancelCnt = lo_objDas.GetParam("@po_intCancelCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetContainerCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더 비용 목록
        /// </summary>
        /// <param name="objReqContainerPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerPayList> GetContainerPayList(int intCenterCode, Int64 intOrderNo, string strAccessCenterCode)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerPayList REQ] {intCenterCode} | {intOrderNo} | {strAccessCenterCode}", bLogWrite);
            
            string                             lo_strJson   = string.Empty;
            ServiceResult<ResContainerPayList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   intCenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   strAccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResContainerPayList
                {
                    list      = new List<ContainerPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ContainerPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetContainerPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 비용 등록
        /// </summary>
        /// <param name="objContainerPayModel"></param>
        /// <returns></returns>
        public ServiceResult<ContainerPayModel> SetContainerPayIns(ContainerPayModel objContainerPayModel)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayIns REQ] {JsonConvert.SerializeObject(objContainerPayModel)}", bLogWrite);

            ServiceResult<ContainerPayModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ContainerPayModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objContainerPayModel.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objContainerPayModel.OrderNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",        DBType.adBigInt,    objContainerPayModel.GoodsSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",     DBType.adBigInt,    objContainerPayModel.DispatchSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",           DBType.adTinyInt,   objContainerPayModel.PayType,           0,       ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_intTaxKind",           DBType.adTinyInt,   objContainerPayModel.TaxKind,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",          DBType.adVarChar,   objContainerPayModel.ItemCode,          5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,    objContainerPayModel.ClientCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",        DBType.adVarWChar,  objContainerPayModel.ClientName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",          DBType.adBigInt,    objContainerPayModel.RefSeqNo,          0,       ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_intCarDivType",        DBType.adTinyInt,   objContainerPayModel.CarDivType,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",           DBType.adBigInt,    objContainerPayModel.ComCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarSeqNo",          DBType.adBigInt,    objContainerPayModel.CarSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",       DBType.adBigInt,    objContainerPayModel.DriverSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",         DBType.adCurrency,  objContainerPayModel.SupplyAmt,         0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intTaxAmt",            DBType.adCurrency,  objContainerPayModel.TaxAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",  DBType.adTinyInt,   objContainerPayModel.InsureExceptKind,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",        DBType.adVarChar,   objContainerPayModel.RegAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",      DBType.adVarWChar,  objContainerPayModel.RegAdminName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",             DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_PAY_TX_INS");


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
                objContainerPayModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objContainerPayModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetContainerPayIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 비용 수정
        /// </summary>
        /// <param name="objContainerPayModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetContainerPayUpd(ContainerPayModel objContainerPayModel)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayUpd REQ] {JsonConvert.SerializeObject(objContainerPayModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",             DBType.adBigInt,    objContainerPayModel.SeqNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objContainerPayModel.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objContainerPayModel.OrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsSeqNo",        DBType.adBigInt,    objContainerPayModel.GoodsSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",     DBType.adBigInt,    objContainerPayModel.DispatchSeqNo,      0,       ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_intPayType",           DBType.adTinyInt,   objContainerPayModel.PayType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxKind",           DBType.adTinyInt,   objContainerPayModel.TaxKind,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",          DBType.adVarChar,   objContainerPayModel.ItemCode,           5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,    objContainerPayModel.ClientCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",        DBType.adVarWChar,  objContainerPayModel.ClientName,         50,      ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_intRefSeqNo",          DBType.adBigInt,    objContainerPayModel.RefSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",        DBType.adTinyInt,   objContainerPayModel.CarDivType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",           DBType.adBigInt,    objContainerPayModel.ComCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarSeqNo",          DBType.adBigInt,    objContainerPayModel.CarSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",       DBType.adBigInt,    objContainerPayModel.DriverSeqNo,        0,       ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_intSupplyAmt",         DBType.adCurrency,  objContainerPayModel.SupplyAmt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTaxAmt",            DBType.adCurrency,  objContainerPayModel.TaxAmt,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",  DBType.adTinyInt,   objContainerPayModel.InsureExceptKind,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",        DBType.adVarChar,   objContainerPayModel.UpdAdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",      DBType.adVarWChar,  objContainerPayModel.UpdAdminName,       50,      ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_PAY_TX_UPD");


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
                                     , 9101, "System error(SetContainerPayUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 비용 삭제
        /// </summary>
        /// <param name="objContainerPayModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetContainerPayDel(long intSeqNo, int intCenterCode, long intOrderNo, int intPayType, string strAdminID, string strAdminName)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayDel REQ] {intSeqNo} | {intCenterCode} | {intOrderNo} | {intPayType} | {strAdminID} | {strAdminName}", bLogWrite);

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

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_PAY_TX_DEL");


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
                                     , 9101, "System error(SetContainerPayDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[SetContainerPayDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너 오더 항목별 비용 목록
        /// </summary>
        /// <param name="objReqContainerPayItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerPayItemList> GetContainerPayItemList(ReqContainerPayItemList objReqContainerPayItemList)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerPayItemList REQ] {JsonConvert.SerializeObject(objReqContainerPayItemList)}", bLogWrite);
            
            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResContainerPayItemList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerPayItemList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",                        DBType.adBigInt,    objReqContainerPayItemList.OrderNo,                       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objReqContainerPayItemList.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                       DBType.adVarChar,   objReqContainerPayItemList.DateFrom,                      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                         DBType.adVarChar,   objReqContainerPayItemList.DateTo,                        8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",             DBType.adVarChar,   objReqContainerPayItemList.OrderLocationCodes,            4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderItemCodes",                 DBType.adVarChar,   objReqContainerPayItemList.OrderItemCodes,                4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",                DBType.adVarWChar,  objReqContainerPayItemList.OrderClientName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",          DBType.adVarWChar,  objReqContainerPayItemList.OrderClientChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",                  DBType.adVarWChar,  objReqContainerPayItemList.PayClientName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",            DBType.adVarWChar,  objReqContainerPayItemList.PayClientChargeName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeLocation",        DBType.adVarWChar,  objReqContainerPayItemList.PayClientChargeLocation,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objReqContainerPayItemList.ConsignorName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                        DBType.adVarWChar,  objReqContainerPayItemList.ComName,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                          DBType.adVarWChar,  objReqContainerPayItemList.CarNo,                         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objReqContainerPayItemList.PickupPlace,                   200,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAcceptAdminName",                DBType.adVarWChar,  objReqContainerPayItemList.AcceptAdminName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objReqContainerPayItemList.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShippingCompany",                DBType.adVarWChar,  objReqContainerPayItemList.ShippingCompany,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCntrNo",                         DBType.adVarChar,   objReqContainerPayItemList.CntrNo,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBLNo",                           DBType.adVarChar,   objReqContainerPayItemList.BLNo,                          5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMyChargeFlag",                   DBType.adChar,      objReqContainerPayItemList.MyChargeFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",                    DBType.adChar,      objReqContainerPayItemList.MyOrderFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                        DBType.adChar,      objReqContainerPayItemList.CnlFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                        DBType.adVarChar,   objReqContainerPayItemList.AdminID,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",               DBType.adVarChar,   objReqContainerPayItemList.AccessCenterCode,              512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",                      DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_PAY_ITEM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResContainerPayItemList
                {
                    list      = new List<ContainerPayItemModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ContainerPayItemModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetContainerPayItemList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerPayItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 컨테이너오더 카운트
        /// </summary>
        /// <param name="objReqContainerOrderCount"></param>
        /// <returns></returns>
        public ServiceResult<ResContainerOrderCount> GetContainerOrderCount(ReqContainerOrderCount objReqContainerOrderCount)
        {
            SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerOrderCount REQ] {JsonConvert.SerializeObject(objReqContainerOrderCount)}", bLogWrite);

            ServiceResult<ResContainerOrderCount> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResContainerOrderCount>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqContainerOrderCount.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strWebRegRequestCnt",   DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strWebUpdRequestCnt",   DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                                                                                                                                 
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTAINER_COUNT_NT_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResContainerOrderCount
                {
                    WebRegRequestCnt = lo_objDas.GetParam("@po_strWebRegRequestCnt").ToInt(),
                    WebUpdRequestCnt = lo_objDas.GetParam("@po_strWebUpdRequestCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetContainerOrderCount)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ContainerDasServices", "I", $"[GetContainerOrderCount RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}