<%@ WebHandler Language="C#" Class="SpecialNoteHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;

///================================================================
/// <summary>
/// FileName        : SpecialNoteHandler.ashx
/// Description     : 거래처 특이사항 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemClientNoteHandler
/// Author          : sybyun96@logislab.com, 2022-07-28
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SpecialNoteHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/SpecialNote"; //필수

    // 메소드 리스트
    private const string MethodClientNote    = "ClientNote";
    private const string MethodClientNoteUpd = "ClientNoteUpdate";

    ClientDasServices    objClientDasServices    = new ClientDasServices();
    ConsignorDasServices objConsignorDasServices = new ConsignorDasServices();

    private string strCallType      = string.Empty;
    private string strCenterCode    = string.Empty;
    private string strClientCode    = string.Empty;
    private string strConsignorCode = string.Empty;
    private string strNote          = string.Empty;
    private string strType          = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodClientNote,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientNoteUpd, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SpecialNoteHandler");
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
            strConsignorCode = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strClientCode    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),    "0");
            strNote          = SiteGlobal.GetRequestForm("Note");
            strType          = Utils.IsNull(SiteGlobal.GetRequestForm("Type"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
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
                case MethodClientNote:
                    GetClientNote();
                    break;
                case MethodClientNoteUpd:
                    SetClientNoteUpd();
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

            SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 업체 정보 & 비고
    /// </summary>
    protected void GetClientNote()
    {   
        ReqClientList                   lo_objReqClientList    = null;
        ServiceResult<ResClientList>    lo_objResClientList    = null;
        ReqConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResConsignorList> lo_objResConsignorList = null;

        if (string.IsNullOrWhiteSpace(strType) || strType.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        } 

        if((strType.Equals("1") || strType.Equals("2")) && (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if(strType.Equals("3") && (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0")))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strType.Equals("1") || strType.Equals("2"))
        {
            try
            {
                lo_objReqClientList = new ReqClientList
                {
                    ClientCode       = strClientCode.ToInt(),
                    CenterCode       = strCenterCode.ToInt(),
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = 0,
                    PageNo           = 0
                };

                lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
                if (lo_objResClientList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = 9004;
                    objResMap.ErrMsg  = "고객사 정보를 찾지 못했습니다.";
                    return;
                }
                
                if (!lo_objResClientList.data.RecordCnt.Equals(1))
                {
                    objResMap.RetCode = 9005;
                    objResMap.ErrMsg  = "고객사 정보를 찾지 못했습니다.";
                    return;
                }
                
                objResMap.Add("CenterCode", lo_objResClientList.data.list[0].CenterCode);
                objResMap.Add("ClientName", lo_objResClientList.data.list[0].ClientName);
                objResMap.Add("ClientCorpNo", lo_objResClientList.data.list[0].ClientCorpNo);

                switch (strType)
                {
                    case "1":
                        objResMap.Add("ClientNote", lo_objResClientList.data.list[0].ClientNote2);
                        break;
                    case "2":
                        objResMap.Add("ClientNote", lo_objResClientList.data.list[0].ClientNote4);
                        break;
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
        else if (strType.Equals("3"))
        {
            try
            {
                lo_objReqConsignorList = new ReqConsignorList
                {
                    CenterCode       = strCenterCode.ToInt(),
                    ConsignorCode    = strConsignorCode.ToInt(),
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = 0,
                    PageNo           = 0
                };

                lo_objResConsignorList = objConsignorDasServices.GetConsignorList(lo_objReqConsignorList);
                if (lo_objResConsignorList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = 9004;
                    objResMap.ErrMsg  = "화주 정보를 찾지 못했습니다.";
                    return;
                }
                
                if (!lo_objResConsignorList.data.RecordCnt.Equals(1))
                {
                    objResMap.RetCode = 9005;
                    objResMap.ErrMsg  = "화주 정보를 찾지 못했습니다.";
                    return;
                }
                
                objResMap.Add("CenterCode",    lo_objResConsignorList.data.list[0].CenterCode);
                objResMap.Add("ConsignorName", lo_objResConsignorList.data.list[0].ConsignorName);
                objResMap.Add("ConsignorNote", lo_objResConsignorList.data.list[0].ConsignorNote);
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
    }

    /// <summary>
    /// 비고 수정
    /// </summary>
    protected void SetClientNoteUpd()
    {
        ReqClientNoteUpd    lo_objReqClientNoteUpd = null;
        ServiceResult<bool> lo_objResClientNoteUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strType) || strType.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        } 

        if((strType.Equals("1") || strType.Equals("2")) && (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if(strType.Equals("3") && (string.IsNullOrWhiteSpace(strClientCode) || strConsignorCode.Equals("0")))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientNoteUpd = new ReqClientNoteUpd
            {
                CenterCode    = strCenterCode.ToInt(),
                ClientCode    = strClientCode.ToInt64(),
                ConsignorCode = strConsignorCode.ToInt64(),
                Type          = strType.ToInt(),
                Note          = strNote,
                AdminID       = objSes.AdminID
            };

            lo_objResClientNoteUpd = objClientDasServices.SetClientNoteUpd(lo_objReqClientNoteUpd);
            objResMap.RetCode      = lo_objResClientNoteUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientNoteUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SpecialNoteHandler", "Exception",
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