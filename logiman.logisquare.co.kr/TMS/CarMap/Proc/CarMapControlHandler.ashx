<%@ WebHandler Language="C#" Class="CarMapControlHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : CarMapControlHandler.ashx
/// Description     : 차량과제 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemClientHandler
/// Author          : shadow54@logislab.com, 2022-07-12
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CarMapControlHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CarMap/CarMapControlList"; //필수

    // 메소드 리스트
    private const string MethodGPSDriverList = "GPSDriverList";
    private const string MethodGPSOrderList  = "GPSOrderList";

    CarMapDasServices   objCarMapDasServices = new CarMapDasServices();
    private HttpContext objHttpContext       = null;

    private string strCallType   = string.Empty;
    private int    intPageSize   = 0;
    private int    intPageNo     = 0;
    private string strOrderNo    = string.Empty;
    private string strCenterCode = string.Empty;
    private string strDateType   = string.Empty;
    private string strDateFrom   = string.Empty;
    private string strCarNo      = string.Empty;
    private string strDriverCell = string.Empty;
    private string strCarDivType = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodGPSDriverList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodGPSOrderList,  MenuAuthType.ReadOnly);
        
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
            strCallType  = SiteGlobal.GetRequestForm("CallType");
            intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ClientHandler");
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
            strOrderNo    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType   = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "1");
            strDateFrom   = SiteGlobal.GetRequestForm("DateFrom");
            strCarNo      = SiteGlobal.GetRequestForm("CarNo");
            strDriverCell = SiteGlobal.GetRequestForm("DriverCell");
            strCarDivType = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
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
                case MethodGPSDriverList:
                    GetGPSDriverList();
                    break;
                case MethodGPSOrderList:
                    GetGPSOrderList();
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

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    ///  GPS 정보 조회(기사정보)
    /// </summary>
    protected void GetGPSDriverList()
    {
        ReqCarMapList                lo_objReqCarMapList = null;
        ServiceResult<ResCarMapList> lo_objResCarMapList = null;

        try
        {
            lo_objReqCarMapList = new ReqCarMapList
            {
                CenterCode = strCenterCode.ToInt(),
                DriverCell = strDriverCell,
                CarNo      = strCarNo,
                DateFrom   = strDateFrom.Replace("-",""),
                CarDivType = strCarDivType.ToInt(),
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCarMapList   = objCarMapDasServices.GetGPSDriverList(lo_objReqCarMapList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCarMapList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    ///  GPS 오더 정보 조회
    /// </summary>
    protected void GetGPSOrderList()
    {
        ReqCarMapList                lo_objReqCarMapList = null;
        ServiceResult<ResCarMapList> lo_objResCarMapList = null;

        try
        {
            lo_objReqCarMapList = new ReqCarMapList
            {
                OrderNo    = strOrderNo.ToInt64(),
                CenterCode = strCenterCode.ToInt(),
                DriverCell = strDriverCell,
                CarNo      = strCarNo,
                DateType   = strDateType.ToInt(),
                DateFrom   = strDateFrom.Replace("-",""),
                CarDivType = strCarDivType.ToInt(),
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCarMapList   = objCarMapDasServices.GetGPSOrderList(lo_objReqCarMapList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCarMapList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
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