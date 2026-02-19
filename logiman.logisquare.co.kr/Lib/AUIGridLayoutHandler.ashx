<%@ WebHandler Language="C#" Class="AUIGridLayout" %>
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.IO;
using System.Web;
using CommonLibrary.Constants;
using Newtonsoft.Json;

public class AUIGridLayout : AshxBaseHandler
{
    // 메소드 리스트
    private const string MethodGridHeaderSave   = "GridHeaderSave";   //그리드 저장
    private const string MethodGridHeaderLoad   = "GridHeaderLoad";   //저장 된 그리드 불러오기
    private const string MethodGridHeaderDelete = "GridHeaderDelete"; //그리드 항목 저장 삭제
        
    private string strCallType   = string.Empty;
    private string strGridKey    = string.Empty;
    private string strGridHeader = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    /// 
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodGridHeaderSave,   MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodGridHeaderLoad,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodGridHeaderDelete, MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        IgnoreCheckMenuAuth();
    
        base.ProcessRequest(context);

        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try {

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
            objResMap.RetCode = 9210;
            objResMap.ErrMsg  = lo_ex.Message + "\r\n" + lo_ex.StackTrace;

            SiteGlobal.WriteLog("AUIGridLayout",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AUIGridLayout");
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
            strCallType   = SiteGlobal.GetRequestForm("CallType");
            strGridKey    = SiteGlobal.GetRequestForm("GridKey");
            strGridHeader = SiteGlobal.GetRequestForm("GridHeader");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AUIGridLayout",
                                "Exception",
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
                case MethodGridHeaderSave:
                    GridHeaderSave();
                    break;
                case MethodGridHeaderLoad:
                    GridHeaderLoad();
                    break;
                case MethodGridHeaderDelete:
                    GridHeaderDelete();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method";
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AUIGridLayout",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
        
    #region Handler Process
    /// <summary>
    /// 그리드 항목 저장
    /// </summary>
    protected void GridHeaderSave()
    {
        DirectoryInfo lo_objDi         = null;
        FileInfo      lo_objFileInfo   = null;
        FileStream    lo_objFileStream = null;
        TextWriter    lo_objTextWriter = null;
            
        if (string.IsNullOrWhiteSpace(strGridKey) || string.IsNullOrWhiteSpace(strGridHeader))
        {
            objResMap.RetCode = 9991;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objDi = new DirectoryInfo(SiteGlobal.FILE_SERVER_ROOT + @"\AUIGRID\");

            if (!lo_objDi.Exists)
            {
                lo_objDi.Create();
            }

            lo_objFileInfo = new FileInfo(lo_objDi + objSes.AdminID + "_" + strGridKey + ".json");

            if (lo_objFileInfo.Exists)
            {
                lo_objFileInfo.Delete();
            }
            
            lo_objFileStream = lo_objFileInfo.OpenWrite();
            lo_objTextWriter = new StreamWriter(lo_objFileStream);
            lo_objTextWriter.Write(strGridHeader);

            objResMap.RetCode = 0;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9965;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AUIGridLayout", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9965);
        }
        finally
        {
            lo_objTextWriter?.Close();
            lo_objFileStream?.Close();
        }
    }

    /// <summary>
    /// 그리드 항목 조회
    /// </summary>
    protected void GridHeaderLoad()
    {
        string   lo_strFilePath  = string.Empty;
        string   lo_strTextValue = string.Empty;
        FileInfo lo_objFileInfo  = null;
            
        if (string.IsNullOrWhiteSpace(strGridKey))
        {
            objResMap.RetCode = 9991;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strFilePath = SiteGlobal.FILE_SERVER_ROOT + @"\AUIGrid\" + objSes.AdminID + "_" + strGridKey + ".json";
            lo_objFileInfo = new FileInfo(lo_strFilePath);

            if (!lo_objFileInfo.Exists)
            {
                objResMap.RetCode = 9992;
                objResMap.ErrMsg  = "저장된 항목설정파일이 없습니다.";
                return;
            }
            
            lo_strTextValue = File.ReadAllText(lo_strFilePath);
            lo_strTextValue = lo_strTextValue.Replace("^", "\"");
            lo_strTextValue = lo_strTextValue.Replace("★", "/>");
            lo_strTextValue = lo_strTextValue.Replace("☆", "<");
                
            objResMap.RetCode = 0;
            objResMap.Add("GridLayout", JsonConvert.SerializeObject(lo_strTextValue));
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9966;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;
            SiteGlobal.WriteLog("AUIGridLayout", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9966);
        }
    }

    /// <summary>
    /// 그리드 항목 삭제
    /// </summary>
    protected void GridHeaderDelete()
    {
        string   lo_strFilePath = string.Empty;
        FileInfo lo_objFileInfo = null;
            
        if (string.IsNullOrWhiteSpace(strGridKey))
        {
            objResMap.RetCode = 9991;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strFilePath = SiteGlobal.FILE_SERVER_ROOT + @"\AUIGrid\" + objSes.AdminID + "_" + strGridKey + ".json";
            lo_objFileInfo = new FileInfo(lo_strFilePath);

            if (lo_objFileInfo.Exists)
            {
                lo_objFileInfo.Delete();
            }
            
            objResMap.RetCode = 0;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9967;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;
            SiteGlobal.WriteLog("AUIGridLayout", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9967);
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