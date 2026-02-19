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
    public class BoardDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 게시판 목록
        /// </summary>
        /// <param name="objReqBoardList"></param>
        /// <returns></returns>
        public ServiceResult<ResBoardList> GetBoardList(ReqBoardList objReqBoardList)
        {
            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[GetBoardList REQ] {JsonConvert.SerializeObject(objReqBoardList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResBoardList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResBoardList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",              DBType.adInteger,     objReqBoardList.SeqNo,              0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBoardViewType",      DBType.adTinyInt,     objReqBoardList.BoardViewType,      0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBoardKind",          DBType.adTinyInt,     objReqBoardList.BoardKind,          0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMainDisplayFlag",    DBType.adChar,        objReqBoardList.MainDisplayFlag,    1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBoardTitle",         DBType.adVarWChar,    objReqBoardList.BoardTitle,         100,   ParameterDirection.Input);
                                                                                      
                lo_objDas.AddParam("@pi_strBoardContent",       DBType.adVarWChar,    objReqBoardList.BoardContent,       100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNewArticleFlag",     DBType.adChar,        objReqBoardList.NewArticleFlag,     1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,        objReqBoardList.UseFlag,            1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToDayYMD",           DBType.adVarChar,     objReqBoardList.ToDayYMD,           8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,     objReqBoardList.AccessCenterCode,   512,   ParameterDirection.Input);
                                                                                                                                 
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt,     objReqBoardList.GradeCode,          0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,     objReqBoardList.AdminID,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",          DBType.adVarWChar,    objReqBoardList.AdminName,          20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,     objReqBoardList.PageSize,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,     objReqBoardList.PageNo,             0,     ParameterDirection.Input);
                                                                                                                                 
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,     DBNull.Value,                       0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResBoardList
                {
                    list      = new List<BoardViewGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<BoardViewGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetBoardList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[GetBoardList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 게시물 등록
        /// </summary>
        /// <param name="objBoardViewModel"></param>
        /// <returns></returns>
        public ServiceResult<BoardViewModel> SetBoardIns(BoardViewModel objBoardViewModel)
        {
            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardIns REQ] {JsonConvert.SerializeObject(objBoardViewModel)}", bLogWrite);

            int                           lo_lenCount  = 100;
            ServiceResult<BoardViewModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            if (!objBoardViewModel.BoardContent.Equals(""))
            {
                lo_lenCount = objBoardViewModel.BoardContent.Length * 2;
            }

            try
            {
                lo_objResult = new ServiceResult<BoardViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intBoardViewType",      DBType.adTinyInt,     objBoardViewModel.BoardViewType,    0,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBoardKind",          DBType.adTinyInt,     objBoardViewModel.BoardKind,        0,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMainDisplayFlag",    DBType.adChar,        objBoardViewModel.MainDisplayFlag,  1,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBoardTitle",         DBType.adVarWChar,    objBoardViewModel.BoardTitle,       100,           ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBoardContent",       DBType.adVarWChar,    objBoardViewModel.BoardContent,     lo_lenCount,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,        objBoardViewModel.UseFlag,          1,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessGradeCode",    DBType.adVarChar,     objBoardViewModel.AccessGradeCode,  512,           ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,     objBoardViewModel.AccessCenterCode, 512,           ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,     objBoardViewModel.AdminID,          50,            ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminNAME",          DBType.adVarWChar,    objBoardViewModel.AdminName,        20,            ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strStartDate",          DBType.adVarChar,     objBoardViewModel.StartDate,        8,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndDate",            DBType.adVarChar,     objBoardViewModel.EndDate,          8,             ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",              DBType.adInteger,     DBNull.Value,                       0,             ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,     DBNull.Value,                       256,           ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,     DBNull.Value,                       0,             ParameterDirection.Output);
                                                                                                                          
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,     DBNull.Value,                       256,           ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,     DBNull.Value,                       0,             ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_TX_INS");


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
                objBoardViewModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();
                lo_objResult.data       = objBoardViewModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(fail to SetBoardIns log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 게시물 등록
        /// </summary>
        /// <param name="objBoardViewModel"></param>
        /// <returns></returns>
        public ServiceResult<BoardViewModel> SetBoardUpd(BoardViewModel objBoardViewModel)
        {

            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardUpd REQ] {JsonConvert.SerializeObject(objBoardViewModel)}", bLogWrite);

            int                           lo_lenCount  = 100;
            ServiceResult<BoardViewModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            if (!objBoardViewModel.BoardContent.Equals(""))
            {
                lo_lenCount = objBoardViewModel.BoardContent.Length * 2;
            }

            try
            {
                lo_objResult = new ServiceResult<BoardViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",              DBType.adInteger,       objBoardViewModel.SeqNo,            0,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBoardViewType",      DBType.adTinyInt,       objBoardViewModel.BoardViewType,    0,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBoardKind",          DBType.adTinyInt,       objBoardViewModel.BoardKind,        0,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMainDisplayFlag",    DBType.adChar,          objBoardViewModel.MainDisplayFlag,  1,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBoardTitle",         DBType.adVarWChar,      objBoardViewModel.BoardTitle,       100,           ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBoardContent",       DBType.adVarWChar,      objBoardViewModel.BoardContent,     lo_lenCount,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,          objBoardViewModel.UseFlag,          1,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessGradeCode",    DBType.adVarChar,       objBoardViewModel.AccessGradeCode,  512,           ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,       objBoardViewModel.AccessCenterCode, 512,           ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,       objBoardViewModel.AdminID,          50,            ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminNAME",          DBType.adVarWChar,      objBoardViewModel.AdminName,        20,            ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartDate",          DBType.adVarChar,       objBoardViewModel.StartDate,        8,             ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndDate",            DBType.adVarChar,       objBoardViewModel.EndDate,          8,             ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,       DBNull.Value,                       256,           ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,       DBNull.Value,                       0,             ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,       DBNull.Value,                       256,           ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,       DBNull.Value,                       0,             ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_TX_UPD");


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
                                     , 9103, "System error(fail to SetBoardUpd log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 게시판 목록
        /// </summary>
        /// <param name="objReqBoardList"></param>
        /// <returns></returns>
        public ServiceResult<ResBoardList> GetBoardFileList(ReqBoardList objReqBoardList)
        {
            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[GetBoardFileList REQ] {JsonConvert.SerializeObject(objReqBoardList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResBoardList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResBoardList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",     DBType.adInteger,    objReqBoardList.SeqNo,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt", DBType.adInteger,    DBNull.Value,             0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_FILE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResBoardList
                {
                    list      = new List<BoardViewGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<BoardViewGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetBoardFileList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[GetBoardFileList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 파일등록
        /// </summary>
        /// <param name="objBoardViewModel"></param>
        /// <returns></returns>
        public ServiceResult<BoardViewModel> SetBoardFileIns(BoardViewModel objBoardViewModel)
        {
            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardFileIns REQ] {JsonConvert.SerializeObject(objBoardViewModel)}", bLogWrite);

            ServiceResult<BoardViewModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<BoardViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",          DBType.adInteger,   objBoardViewModel.SeqNo,          0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFileName",       DBType.adVarWChar,  objBoardViewModel.FileName,       100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFileNameNew",    DBType.adVarWChar,  objBoardViewModel.FileNameNew,    100,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                     256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                     0,     ParameterDirection.Output);
                                                                                                                         
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                     256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                     0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_FILE_TX_INS");


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
                                     , 9103, "System error(fail to SetBoardFileIns log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardFileIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 파일삭제
        /// </summary>
        /// <param name="objBoardViewModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetBoardFileDel(int lo_intSeqNo)
        {
            SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardFileDel REQ] {lo_intSeqNo}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intFileSeqNo",      DBType.adInteger,       lo_intSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,       DBNull.Value,     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,       DBNull.Value,     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,       DBNull.Value,     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,       DBNull.Value,     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BOARD_MANAGER_FILE_TX_DEL");

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
                                     , 9103, "System error(fail to SetBoardFileDel log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("BoardDasServices", "I", $"[SetBoardFileDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}