<%@ WebHandler Language="C#" Class="BoardFileHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : BoardFileHandler.ashx
/// Description     : 게시판 파일 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee@logislab.com, 2022-09-01
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class BoardFileHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Board/BoardIns"; //필수

    // 메소드 리스트
    private const string MethodBoardFileUpload    = "BoardFileUpload";
    private const string MethodBoardFileDownload  = "BoardFileDownload";
    private const string MethodBoardFileDelete    = "BoardFileDelete";
    private const string MethodBoardInsFileUpload = "BoardInsFileUpload";

    private string strCallType    = string.Empty;
    private string strCenterCode  = string.Empty;
    private string strOrderNo     = string.Empty;
    private string strFileSeqNo   = string.Empty;
    private string strFileNameNew = string.Empty;
    private string strFileName    = string.Empty;
    private string strTempFlag    = string.Empty;
    private string strFileRegType = string.Empty;
    private string strSeqNo       = string.Empty;

    BoardDasServices objBoardDasServices = new BoardDasServices();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodBoardFileUpload,    MenuAuthType.All);
        objMethodAuthList.Add(MethodBoardFileDownload,  MenuAuthType.All);
        objMethodAuthList.Add(MethodBoardFileDelete,    MenuAuthType.All);
        objMethodAuthList.Add(MethodBoardInsFileUpload, MenuAuthType.All);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);

        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");

            //1.Request
            GetData();

            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            //2.처리
            Process();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("BoardFileHandler");
        }
    }

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
            strCenterCode   = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo      = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strFileSeqNo    = Utils.IsNull(Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileSeqNo")), "0");
            strTempFlag     = SiteGlobal.GetRequestForm("TempFlag");
            strFileNameNew  = SiteGlobal.GetRequestForm("FileNameNew");
            strFileName     = SiteGlobal.GetRequestForm("FileName");
            strFileRegType  = Utils.IsNull(SiteGlobal.GetRequestForm("FileRegType"), "0");
            strSeqNo        = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    ///------------------------------
    /// <summary>
    /// 실행 메소드 처리함수
    /// </summary>
    ///------------------------------
    private void Process()
    {
        try
        {
            switch (strCallType)
            {
                case MethodBoardFileUpload:
                    SetFileUpload();
                    break;
                case MethodBoardFileDownload:
                    SetFileDownload();
                    break;
                case MethodBoardFileDelete:
                    SetFileDelete();
                    break;
                case MethodBoardInsFileUpload:
                    SetInsFileUpload();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 파일목록
    /// </summary>
    protected void GetFileList()
    {
        ReqBoardList                lo_objReqBoardFileList = null;
        ServiceResult<ResBoardList> lo_objResBoardFileList = null;

        if (string.IsNullOrWhiteSpace(strOrderNo) || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqBoardFileList = new ReqBoardList
            {
                SeqNo = strSeqNo.ToInt()
            };

            lo_objResBoardFileList = objBoardDasServices.GetBoardFileList(lo_objReqBoardFileList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResBoardFileList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 업로드
    /// </summary>
    private void SetFileUpload()
    {
        string         lo_strExtension      = string.Empty;
        string         lo_strFileName       = string.Empty;
        string         lo_strFileNameNew    = string.Empty;
        string         lo_strFileDir        = string.Empty;
        string         lo_strFilePath       = string.Empty;
        Random         lo_objRnd            = new Random();
        DirectoryInfo  lo_objDi             = null;
        HttpPostedFile lo_objHttpPostedFile = null;

        //1개 파일업로드만 허용
        if (!objRequest.Files.Count.Equals(1))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "하나의 파일만 첨부할 수 있습니다.";
            return;
        }

        try
        {
            lo_objHttpPostedFile = objRequest.Files[0];

            // 파일 업로드
            try
            {
                lo_strExtension   = Path.GetExtension(lo_objHttpPostedFile.FileName).ToLower().Replace(".", "");
                lo_strFileName    = Path.GetFileName(lo_objHttpPostedFile.FileName).ToLower();
                lo_strFileNameNew = "O" + DateTime.Now.ToString("yyyyMMddHHmmss") + lo_objRnd.Next(1000, 10000) + "." + lo_strExtension;
                lo_strFileDir     = SiteGlobal.FILE_SERVER_ROOT + @"\BOARD\Temp\";
                lo_objDi          = new DirectoryInfo(lo_strFileDir);

                if (!lo_objDi.Exists)
                {
                    lo_objDi.Create();
                }

                if (lo_objHttpPostedFile.ContentLength.Equals(0))
                {
                    objResMap.RetCode = 9001;
                    objResMap.ErrMsg = "첨부된 파일이 없습니다.";
                    return;
                }

                if (lo_objHttpPostedFile.ContentLength > 1024 * 1024 * 10)
                {
                    objResMap.RetCode = 9002;
                    objResMap.ErrMsg = "첨부파일 용량은 10MB 이내로 등록가능합니다.";
                    return;
                }

                if (!lo_strExtension.Equals("jpg") &&
                    !lo_strExtension.Equals("jpeg") &&
                    !lo_strExtension.Equals("png") &&
                    !lo_strExtension.Equals("pdf")&&
                    !lo_strExtension.Equals("xlsx"))
                {
                    objResMap.RetCode = 9003;
                    objResMap.ErrMsg = "첨부할 수 없는 파일확장자입니다.";
                    return;
                }

                lo_strFilePath = Path.Combine(lo_strFileDir, lo_strFileNameNew);

                if (File.Exists(lo_strFilePath))
                {
                    objResMap.RetCode = 9005;
                    objResMap.ErrMsg = "동일한 파일이 존재합니다.";
                    return;
                }

                lo_objHttpPostedFile.SaveAs(lo_strFilePath);

                if (!File.Exists(lo_strFilePath))
                {
                    objResMap.RetCode = 9006;
                    objResMap.ErrMsg = "파일 업로드에 실패했습니다.";
                    return;
                }

                objResMap.RetCode = 0;
                objResMap.Add("EncFileSeqNo",   Utils.GetEncrypt(string.Empty));
                objResMap.Add("TempFlag",       "Y");
                objResMap.Add("FileName",       lo_strFileName);
                objResMap.Add("EncFileNameNew", lo_strFileNameNew);
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9201;
                objResMap.ErrMsg  = lo_ex.ToString();

                SiteGlobal.WriteLog(
                    "BoardFileHandler",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9201);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog(
                "BoardFileHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }

    /// <summary>
    /// 파일 업로드 및 등록 처리
    /// </summary>
    private void SetInsFileUpload()
    {
        string                        lo_strTempFileDir       = string.Empty;
        string                        lo_strNewFileDir        = string.Empty;
        string                        lo_strNewDBFileDir      = string.Empty;
        DirectoryInfo                 lo_di                   = null;
        BoardViewModel                lo_objBoardViewModel    = null;
        ServiceResult<BoardViewModel> lo_objResBoardViewModel = null;

        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFileNameNew))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFileName))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //파일 이동
        try
        {
            //업로드 파일 확인
            lo_strTempFileDir = SiteGlobal.FILE_SERVER_ROOT + @"\BOARD\Temp\";

            if (!File.Exists(lo_strTempFileDir + strFileNameNew))
            {
                objResMap.RetCode = 9201;
                objResMap.ErrMsg  = "등록할 파일이 없습니다." + strFileNameNew;
                return;
            }

            try
            {
                lo_objBoardViewModel = new BoardViewModel
                {
                    SeqNo       = strSeqNo.ToInt(),
                    FileName    = strFileName,
                    FileNameNew = strFileNameNew
                };

                lo_objResBoardViewModel = objBoardDasServices.SetBoardFileIns(lo_objBoardViewModel);
                objResMap.RetCode       = lo_objResBoardViewModel.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResBoardViewModel.result.ErrorMsg;
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9201;
                objResMap.ErrMsg  = lo_ex.ToString();

                SiteGlobal.WriteLog(
                    "BoardFileHandler",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9201);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog(
                "BoardFileHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }

    /// <summary>
    /// 파일 삭제
    /// </summary>
    private void SetFileDelete()
    {
        string              lo_strFileDir      = string.Empty;
        ServiceResult<bool> objResOrderFileDel = null;

        if (string.IsNullOrWhiteSpace(strTempFlag))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFileNameNew))
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFileName))
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            //파일 삭제
            if (strTempFlag.Equals("Y"))
            {
                lo_strFileDir = SiteGlobal.FILE_SERVER_ROOT + @"\BOARD\Temp\";

                if (File.Exists(lo_strFileDir + strFileNameNew))
                {
                    File.Delete(lo_strFileDir + strFileNameNew);
                }

                return;
            }

            //DB 업데이트
            if (!string.IsNullOrWhiteSpace(strFileSeqNo) && !strFileSeqNo.Equals("0") && strTempFlag.Equals("N"))
            {
                objResOrderFileDel = objBoardDasServices.SetBoardFileDel(strFileSeqNo.ToInt());
                
                objResMap.RetCode = objResOrderFileDel.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = objResOrderFileDel.result.ErrorMsg;
                }
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog(
                "BoardFileHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }

    /// <summary>
    /// 파일 다운로드
    /// </summary>
    private void SetFileDownload()
    {
        string lo_strFileDir = string.Empty;

        if (string.IsNullOrEmpty(strFileNameNew))
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = "필요한 값이 없습니다" + strFileNameNew;
            return;
        }

        if (string.IsNullOrEmpty(strFileName))
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }

        if (string.IsNullOrEmpty(strTempFlag))
        {
            objResMap.RetCode = 9204;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }
        
        try
        {
            lo_strFileDir = SiteGlobal.FILE_SERVER_ROOT + @"\BOARD\Temp\";
            
            if (!File.Exists(lo_strFileDir + strFileNameNew))
            {
                objResMap.RetCode = 9204;
                objResMap.ErrMsg  = "파일이 존재하지 않습니다.";
                return;
            }
            
            strFileName = Utils.GetConvertFileName(strFileName, "_");

            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "text/plain";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" + strFileName + ";");
            HttpContext.Current.Response.TransmitFile(lo_strFileDir + strFileNameNew);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Clear();
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "BoardFileHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }

    #endregion


    ///--------------------------------------------
    /// <summary>
    /// 페이지 기본 Json 응답 출력
    /// </summary>
    ///--------------------------------------------
    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
            // ignored
        }
    }
}