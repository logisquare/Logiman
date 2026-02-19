<%@ WebHandler Language="C#" Class="ItemGroupHandler" %>
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
/// FileName        : ItemGroupHandler.ashx
/// Description     : 항목 그룹  Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-07-06
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ItemGroupHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Item/ItemGroupList"; //필수

    // 메소드 리스트
    private const string MethodItemGroupList = "ItemGroupList";
    private const string MethodItemGroupIns  = "ItemGroupInsert";
    ItemDasServices      objItemDasServices  = new ItemDasServices();

    private string strCallType   = string.Empty;
    private int    intPageSize   = 0;
    private int    intPageNo     = 0;
    private string strSeqNo      = string.Empty;
    private string strGroupCode  = string.Empty;
    private string strGroupName  = string.Empty;
    private string strCenterFlag = string.Empty;
    private string strAdminFlag  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodItemGroupList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodItemGroupIns,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("MsgSendLogHandler");
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
            strSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "0");
            strGroupCode  = SiteGlobal.GetRequestForm("GroupCode");
            strGroupName  = SiteGlobal.GetRequestForm("GroupName");
            strCenterFlag = Utils.IsNull(SiteGlobal.GetRequestForm("CenterFlag"), "N");
            strAdminFlag  = Utils.IsNull(SiteGlobal.GetRequestForm("AdminFlag"),  "N");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
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
                case MethodItemGroupList:
                    GetItemGroupList();
                  break;
                case MethodItemGroupIns:
                    SetItemGroupIns();
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

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 항목 그룹 목록
    /// </summary>
    protected void GetItemGroupList()
    {
        ReqItemGroupList                lo_objReqItemGroupList = null;
        ServiceResult<ResItemGroupList> lo_objResItemGroupList = null;

        try
        {
            lo_objReqItemGroupList = new ReqItemGroupList
            {   
                SeqNo       = strSeqNo.ToInt(),
                GroupCode   = strGroupCode,
                GroupName   = strGroupName,
                PageSize    = intPageSize,
                PageNo      = intPageNo
            };

            lo_objResItemGroupList = objItemDasServices.GetItemGroupList(lo_objReqItemGroupList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResItemGroupList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 항목 그룹 등록
    /// </summary>
    protected void SetItemGroupIns()
    {
        ItemGroupModel      lo_objItemGroupModel  = null;
        ServiceResult<bool> lo_objResItemGroupIns = null;
            
        if ((string.IsNullOrWhiteSpace(strGroupCode) && string.IsNullOrWhiteSpace(strGroupName)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strGroupCode = strGroupCode.ToUpper();

        try
        {
            lo_objItemGroupModel = new ItemGroupModel
            {
                GroupCode     = strGroupCode,
                GroupName     = strGroupName,
                CenterFlag    = strCenterFlag,
                AdminFlag     = strAdminFlag,
            };

            lo_objResItemGroupIns = objItemDasServices.SetItemGroupIns(lo_objItemGroupModel);
            objResMap.RetCode       = lo_objResItemGroupIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResItemGroupIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
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