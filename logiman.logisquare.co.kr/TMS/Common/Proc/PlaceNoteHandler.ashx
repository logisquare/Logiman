<%@ WebHandler Language="C#" Class="PlaceNoteHandler" %>
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
/// FileName        : PlaceNoteHandler.ashx
/// Description     : 상하차지 특이사항 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-11-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PlaceNoteHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/PlaceNote"; //필수

    // 메소드 리스트
    private const string MethodPlaceNote    = "PlaceNote";       //상하차지 특이사항
    private const string MethodPlaceNoteUpd = "PlaceNoteUpdate"; //상하차지 특이사항 수정
        
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    
    private string strCallType     = string.Empty;
    private string strPlaceSeqNo   = string.Empty;
    private string strPlaceType    = string.Empty;
    private string strOrderType    = string.Empty;
    private string strCenterCode   = string.Empty;
    private string strPlaceName    = string.Empty;
    private string strPlaceAddr    = string.Empty;
    private string strPlaceAddrDtl = string.Empty;
    private string strPlaceRemark1 = string.Empty;
    private string strPlaceRemark2 = string.Empty;
    private string strPlaceRemark3 = string.Empty;
    private string strPlaceRemark4 = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPlaceNote,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceNoteUpd, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("PlaceNoteHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PlaceNoteHandler");
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
            strPlaceSeqNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "0");
            strPlaceType    = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceType"),  "0");
            strOrderType    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"),  "0");
            strPlaceName    = SiteGlobal.GetRequestForm("PlaceName");
            strPlaceAddr    = SiteGlobal.GetRequestForm("PlaceAddr");
            strPlaceAddrDtl = SiteGlobal.GetRequestForm("PlaceAddrDtl");
            strPlaceRemark1 = SiteGlobal.GetRequestForm("PlaceRemark1");
            strPlaceRemark2 = SiteGlobal.GetRequestForm("PlaceRemark2");
            strPlaceRemark3 = SiteGlobal.GetRequestForm("PlaceRemark3");
            strPlaceRemark4 = SiteGlobal.GetRequestForm("PlaceRemark$");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceNoteHandler", "Exception",
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
                case MethodPlaceNote:
                    GetPlaceNote();
                    break;
                case MethodPlaceNoteUpd:
                    SetPlaceNoteUpd();
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

            SiteGlobal.WriteLog("PlaceNoteHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 상하차지 특이사항
    /// </summary>
    protected void GetPlaceNote()
    {   
        ReqClientPlaceNote                lo_objReqClientPlaceNote = null;
        ServiceResult<ResClientPlaceNote> lo_objResClientPlaceNote = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceNote = new ReqClientPlaceNote
            {
                CenterCode   = strCenterCode.ToInt(),
                PlaceName    = strPlaceName,
                PlaceAddr    = strPlaceAddr,
                PlaceAddrDtl = strPlaceAddrDtl,
                AdminID      = objSes.AdminID
            };

            lo_objResClientPlaceNote = objClientPlaceChargeDasServices.GetClientPlaceNote(lo_objReqClientPlaceNote);
            objResMap.strResponse    = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceNote) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceNoteHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 특이사항 수정
    /// </summary>
    protected void SetPlaceNoteUpd()
    {
        ReqClientPlaceNoteUpd lo_objReqClientPlaceNoteUpd = null;
        ServiceResult<bool>   lo_objResClientPlaceNoteUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderType) || strOrderType.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        } 

        if (string.IsNullOrWhiteSpace(strPlaceSeqNo) || strPlaceSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        } 

        try
        {
            lo_objReqClientPlaceNoteUpd = new ReqClientPlaceNoteUpd
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderType    = strOrderType.ToInt(),
                PlaceSeqNo   = strPlaceSeqNo.ToInt64(),
                PlaceRemark1 = strPlaceRemark1,
                PlaceRemark2 = strPlaceRemark2,
                PlaceRemark3 = strPlaceRemark3,
                PlaceRemark4 = strPlaceRemark4,
                AdminID      = objSes.AdminID
            };

            lo_objResClientPlaceNoteUpd = objClientPlaceChargeDasServices.SetClientPlaceNoteUpd(lo_objReqClientPlaceNoteUpd);
            objResMap.RetCode            = lo_objResClientPlaceNoteUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceNoteUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceNoteHandler", "Exception",
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