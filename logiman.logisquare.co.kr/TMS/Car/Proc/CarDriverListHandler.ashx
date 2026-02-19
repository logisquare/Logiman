<%@ WebHandler Language="C#" Class="CarDriverListHandler" %>
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
/// FileName        : CarDriverListHandler.ashx
/// Description     : 차량현황 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-03-07
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CarDriverListHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Car/CarDriverList"; //필수

    // 메소드 리스트
    private const string MethodCarDriverList    = "CarDriverList"; //기사목록
    private const string MethodCarDriverInfoUpd = "CarDriverInfoUpd";  //기사정보수정

    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private string strCallType    = string.Empty;
    private int    intPageSize    = 0;
    private int    intPageNo      = 0;
    private string strUseFlag     = string.Empty;
    private string strDriverName  = string.Empty;
    private string strDriverCell  = string.Empty;
    private string strDriverSeqNo = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCarDriverList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDriverInfoUpd, MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

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

            SiteGlobal.WriteLog("CarDriverListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CarDriverListHandler");
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
            strUseFlag     = SiteGlobal.GetRequestForm("UseFlag");
            strDriverName  = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell  = SiteGlobal.GetRequestForm("DriverCell");
            strDriverSeqNo = Utils.IsNull( SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDriverListHandler", "Exception",
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
                case MethodCarDriverList:
                    GetCarDriverList();
                    break;
                case MethodCarDriverInfoUpd:
                    SetCarDriverInfoUpd();
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

            SiteGlobal.WriteLog("CarDriverListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 기사목록
    /// </summary>
    protected void GetCarDriverList()
    {

        ReqCarDispatchList                lo_objReqCarDriverList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDriverList = null;

        if (string.IsNullOrWhiteSpace(strDriverName.Replace(" ", "")) && string.IsNullOrWhiteSpace(strDriverCell.Replace(" ", "")))
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = "기사명이나 기사 휴대폰 중 하나를 입력하세요.";
            return;
        }

        try
        {
            lo_objReqCarDriverList = new ReqCarDispatchList
            {
                UseFlag          = strUseFlag,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCarDriverList = objCarDispatchDasServices.GetCarDriverList(lo_objReqCarDriverList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResCarDriverList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDriverListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 기사정보수정
    /// </summary>
    protected void SetCarDriverInfoUpd()
    {
        ReqCarDriverUpd     lo_objReqCarDriverUpd = null;
        ServiceResult<bool> lo_objResCarDriverUpd = null;

        if (string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (objSes.GradeCode > 2)
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "수정할 수 있는 권한이 없습니다.";
            return;
        }

        
        try
        {
            lo_objReqCarDriverUpd = new ReqCarDriverUpd
            {
                DriverSeqNo = strDriverSeqNo.ToInt64(),
                DriverName  = strDriverName,
                UpdAdminID  = objSes.AdminID
            };

            lo_objResCarDriverUpd = objCarDispatchDasServices.SetCarDriverInfoUpd(lo_objReqCarDriverUpd);
            objResMap.RetCode     = lo_objResCarDriverUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDriverListHandler", "Exception",
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