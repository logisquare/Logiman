<%@ WebHandler Language="C#" Class="OrderReceiptListHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : OrderReceiptListHandler.ashx
/// Description     : 정보망 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-18
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderReceiptListHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/OrderReceiptList"; //필수

    // 메소드 리스트
    private const string MethodOrderReceiptList         = "OrderReceiptList"; //증빙 조회
    private const string MethodOrderReceiptFileDownload = "OrderReceiptFileDownload"; //파일 다운로드

    OrderDispatchDasServices  objOrderDispatchDasServices    = new OrderDispatchDasServices();

    private HttpContext objHttpContext   = null;
    private string      strCallType      = string.Empty;
    private int         intPageSize      = 0;
    private int         intPageNo        = 0;
    public  string      strFileSeqNo     = string.Empty;
    public  string      strOrderNo       = string.Empty;
    public  string      strDispatchSeqNo = string.Empty;
    public  string      strCenterCode    = string.Empty;
    public  string      strFileType      = string.Empty;
    public  string      strFileGubun     = string.Empty;
    public  string      strDelFlag       = string.Empty;
    public  string      strFileUrl       = string.Empty;
    public  string      strFileName      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderReceiptList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderReceiptFileDownload, MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        objHttpContext = context;

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("OrderReceiptListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderReceiptListHandler");
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
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "0");
            strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),       "0");
            strDispatchSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strFileSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("FileSeqNo"),     "0");
            strFileType      = Utils.IsNull(SiteGlobal.GetRequestForm("FileType"),      "0");
            strFileGubun     = Utils.IsNull(SiteGlobal.GetRequestForm("FileGubun"),     "0");
            strDelFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("DelFlag"),       "N");
            strFileUrl       = SiteGlobal.GetRequestForm("FileUrl");
            strFileName      = SiteGlobal.GetRequestForm("FileName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderReceiptListHandler", "Exception",
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
                case MethodOrderReceiptList:
                    GetOrderReceiptList();
                    break;
                case MethodOrderReceiptFileDownload:
                    SetOrderReceiptFileDownload();
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

            SiteGlobal.WriteLog("OrderReceiptListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 증빙 조회
    /// </summary>
    protected void GetOrderReceiptList()
    {
        ReqDispatchOrderFileList                lo_objReqDispatchOrderFileList = null;
        ServiceResult<ResDispatchOrderFileList> lo_objResDispatchOrderFileList = null;

        try
        {
            lo_objReqDispatchOrderFileList = new ReqDispatchOrderFileList
            {

                FileSeqNo           = strFileSeqNo.ToInt64(),
                OrderNo             = strOrderNo.ToInt64(),
                DispatchSeqNo       = strDispatchSeqNo.ToInt64(),
                CenterCode          = strCenterCode.ToInt(),
                FileType            = strFileType.ToInt(),
                FileGubun           = strFileGubun.ToInt(),
                DelFlag             = strDelFlag,
                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo,
            };

            lo_objResDispatchOrderFileList = objOrderDispatchDasServices.GetOrderDispatchFile(lo_objReqDispatchOrderFileList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResDispatchOrderFileList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderReceiptListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 다운로드
    /// </summary>
    protected void SetOrderReceiptFileDownload()
    {
        
        int    lo_intRetVal = 0;
        string lo_strErrMsg = string.Empty;

        if (string.IsNullOrWhiteSpace(strFileUrl))
        {
            objResMap.RetCode = 9301;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strFileName))
        {
            objResMap.RetCode = 9302;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_intRetVal = SiteGlobal.DownloadWebUrlToFile(strFileUrl, strFileName, ref lo_strErrMsg);
            
            if(lo_intRetVal.IsFail())
            {
                objResMap.RetCode = 9303;
                objResMap.ErrMsg  = lo_strErrMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderReceiptListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
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
        }
    }
}