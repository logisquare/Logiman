<%@ WebHandler Language="C#" Class="uploadHandler" %>
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
/// FileName        : uploadHandler.ashx
/// Description     : 수출입 오더 파일 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jykee88@logislab.com, 2022-08-03
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class uploadHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Board/BoardIns"; //필수

    // 메소드 리스트
    private const string MethodFileUpload    = "FileUpload";

    private string strCallType    = string.Empty;
    private string strCenterCode  = string.Empty;
    private string strOrderNo     = string.Empty;
    private string strFileSeqNo   = string.Empty;
    private string strFileNameNew = string.Empty;
    private string strFileName    = string.Empty;
    private string strTempFlag    = string.Empty;
    private string strFileRegType = string.Empty;

    OrderDasServices objOrderDasServices = new OrderDasServices();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodFileUpload, MenuAuthType.All);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType     = SiteGlobal.GetRequestForm("CallType");

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

            SiteGlobal.WriteLog("UploadHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse();
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
            strFileNameNew  = Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileNameNew"));
            strFileName     = SiteGlobal.GetRequestForm("FileName");
            strFileRegType  = Utils.IsNull(SiteGlobal.GetRequestForm("FileRegType"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("UploadHandler", "Exception",
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
                case MethodFileUpload:
                    SetFileUpload();
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

            SiteGlobal.WriteLog("UploadHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 파일 업로드
    /// </summary>
    private void SetFileUpload()
    {
        string         lo_strExtension      = string.Empty;
        string         lo_strFileName       = string.Empty;
        string         lo_strFileNameNew    = string.Empty;
        string         lo_strFileDir        = string.Empty;
        string         lo_strOutMsg         = string.Empty;
        Random         lo_rnd               = new Random();
        DirectoryInfo  lo_di                = null;
        HttpPostedFile lo_objHttpPostedFile = null;

        //1개 파일업로드만 허용
        if (!objRequest.Files.Count.Equals(1))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "하나의 파일만 첨부할 수 있습니다." + objRequest.Files.Count;
            return;
        }

        try
        {
            lo_objHttpPostedFile = objRequest.Files[0];

            // 파일 업로드
            try
            {
                lo_strExtension = Path.GetExtension(lo_objHttpPostedFile.FileName).ToLower().Replace(".", "");
                lo_strFileName = Path.GetFileName(lo_objHttpPostedFile.FileName).ToLower();
                lo_strFileNameNew = "O" + DateTime.Now.ToString("yyyyMMddHHmmss") + lo_rnd.Next(1000, 10000) + "." + lo_strExtension;
                lo_strFileDir = SiteGlobal.FILE_SERVER_ROOT + @"Board";
                lo_di = new DirectoryInfo(lo_strFileDir);

                if (!lo_di.Exists)
                {
                    lo_di.Create();
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
                    !lo_strExtension.Equals("png"))
                {
                    objResMap.RetCode = 9003;
                    objResMap.ErrMsg = "첨부할 수 없는 파일확장자입니다.";
                    return;
                }

                if (File.Exists(lo_strFileDir + @"\" + lo_strFileNameNew))
                {
                    objResMap.RetCode = 9005;
                    objResMap.ErrMsg = "동일한 파일이 존재합니다.";
                    return;
                }

                lo_objHttpPostedFile.SaveAs(lo_strFileDir + @"\" + lo_strFileNameNew);

                if (!File.Exists(lo_strFileDir + @"\" + lo_strFileNameNew))
                {
                    objResMap.RetCode = 9006;
                    objResMap.ErrMsg = "파일 업로드에 실패했습니다.";
                    return;
                }
                objResMap.Add("FileFull",  SiteGlobal.FILE_DOMAIN + @"Board\" + lo_strFileNameNew);
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9201;
                objResMap.ErrMsg  = lo_ex.ToString();

                SiteGlobal.WriteLog(
                    "UploadHandler",
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
                "UploadHandler",
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
    private void WriteJsonResponse()
    {
        string lo_strResponse = string.Empty;
        string lo_strErrMsg   = string.Empty;
        int lo_intRetVal = 0;

        try
        {
            //toJsonString() 제어 로직 - strResponse 판단.
            // - Not Null : strResponse 를 리턴
            // - Null     : intRetVal(ErrCode), strErrMsg(ErrMsg)를 Json String 으로 시리얼라이즈하여 리턴                
            lo_strResponse = "1";
        }
        catch (Exception lo_ex)
        {

            lo_intRetVal = 9901;
            SiteGlobal.WriteLog(
                "UploadHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                lo_intRetVal);
        }
        finally
        {
            // 출력
            objResponse.Write(lo_strResponse);
        }
    }
}