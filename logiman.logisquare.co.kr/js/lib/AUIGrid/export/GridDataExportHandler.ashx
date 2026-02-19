<%@ WebHandler Language="C#" Class="GridDataExportHandler" %>
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using CommonLibrary.Constants;

public class GridDataExportHandler : AshxBaseHandler
{
    // 메소드 리스트
    private const string MethodGridDataExport = "GridDataExport"; //그리드 데이터 파일  저장
    private const string MethodGridDataExportLog = "GridDataExportLog"; //그리드 데이터 파일 저장 로그

    private string strCallType  = string.Empty;
    private string strParam     = string.Empty;
    private string strData      = string.Empty;
    private string strFileName  = string.Empty;
    private string strExtension = string.Empty;
    private string strGridID    = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    /// 
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodGridDataExport,    MenuAuthType.All);
        objMethodAuthList.Add(MethodGridDataExportLog, MenuAuthType.All);

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

            SiteGlobal.WriteLog("GridDataExportHandler",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("GridDataExportHandler");
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
            strParam     = SiteGlobal.GetRequestForm("param");
            strCallType  = strParam.Split('^')[0];
            strGridID    = strParam.Split('^')[1];
            strFileName  = strParam.Split('^')[2];
            strData      = SiteGlobal.GetRequestForm("data");
            strExtension = SiteGlobal.GetRequestForm("extension");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("GridDataExportHandler",
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
        string lo_strResponse = string.Empty;

        try
        {
            switch (strCallType)
            {
                case MethodGridDataExport:
                    SetGridDataExport();
                    break;
                case MethodGridDataExportLog:
                    SetGridDataExportLog();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg = "Wrong Method";
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("GridDataExportHandler",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);

            lo_strResponse = string.Format(ERROR_JSON_STRING, objResMap.RetCode, objResMap.ErrMsg);
        }
        finally
        {
            if (!objResMap.RetCode.Equals(0))
            {

                objResponse.Write(lo_strResponse);
            }
        }
    }

    #region Handler Process
    /// <summary>
    /// 그리드 항목 저장
    /// </summary>
    protected void SetGridDataExport()
    {

        if (string.IsNullOrWhiteSpace(strGridID) || string.IsNullOrWhiteSpace(strFileName) || string.IsNullOrWhiteSpace(strData) || string.IsNullOrWhiteSpace(strExtension))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        byte[] strByteData = null;

        SiteGlobal.WriteInformation("GridDataExportHandler", "", $"[GridDataExportHandler] {objSes.AdminID} | {objSes.AdminName} | {strFileName}| {strGridID}", true);

        try
        {
            strByteData = Convert.FromBase64String(strData);
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog("GridDataExportHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9901);
        }

        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + strFileName + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + strExtension);
        if (strByteData != null)
        {
            HttpContext.Current.Response.BinaryWrite(strByteData);
        }
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.Clear();
    }

    /// <summary>
    /// 그리드 항목 저장 로그
    /// </summary>
    protected void SetGridDataExportLog()
    {

        if (string.IsNullOrWhiteSpace(strGridID) || string.IsNullOrWhiteSpace(strFileName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.22";
            return;
        }

        SiteGlobal.WriteInformation("GridDataExportHandler", "", $"[GridDataExportHandler] {objSes.AdminID} | {objSes.AdminName} | {strFileName}| {strGridID}", true);
    }
    #endregion

    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
        }
    }
}