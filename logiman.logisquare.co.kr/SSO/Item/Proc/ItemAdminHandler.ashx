<%@ WebHandler Language="C#" Class="ItemAdminHandler" %>
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
using System.Data;

///================================================================
/// <summary>
/// FileName        : ItemAdminHandler.ashx
/// Description     : 사용자별 항목 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : sybyun96@logislab.com, 2022-07-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ItemAdminHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Item/ItemAdminList"; //필수

    // 메소드 리스트
    private const string MethodItemGroupList  = "ItemGroupList";
    private const string MethodItemAdminList  = "ItemAdminList";
    private const string MethodItemAdminIns   = "ItemAdminInsert";
    private const string MethodMakeItemJson   = "MakeItemJson";
    ItemDasServices      objItemDasServices   = new ItemDasServices();
    private HttpContext  objHttpContext       = null;

    private string strCallType     = string.Empty;
    private int    intPageSize     = 0;
    private int    intPageNo       = 0;
    private string strGroupCode    = string.Empty;
    private string strAdminFlag    = string.Empty;
    private string strItemFullCode = string.Empty;
    private string strBookmarkFlag = string.Empty;
    private string strAdminSort    = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodItemGroupList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodItemAdminList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodItemAdminIns,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodMakeItemJson,  MenuAuthType.ReadWrite);
        
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

            SiteGlobal.WriteLog("ItemAdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ItemAdminHandler");
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
            strGroupCode    = SiteGlobal.GetRequestForm("GroupCode");
            strAdminFlag    = Utils.IsNull(SiteGlobal.GetRequestForm("AdminFlag"), "N");
            strItemFullCode = SiteGlobal.GetRequestForm("ItemFullCode");
            strBookmarkFlag = Utils.IsNull(SiteGlobal.GetRequestForm("BookmarkFlag"), "N");
            strAdminSort = Utils.IsNull(SiteGlobal.GetRequestForm("AdminSort"), "0");
            
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ItemAdminHandler", "Exception",
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
                case MethodItemAdminList:
                    GetItemAdminList();
                    break;
                case MethodItemAdminIns:
                    SetItemAdminIns();
                    break;
                case MethodMakeItemJson:
                    SetMakeItemJson();
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

            SiteGlobal.WriteLog("ItemAdminHandler", "Exception",
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
                AdminFlag   = strAdminFlag,
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

            SiteGlobal.WriteLog("ItemAdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 사용자 항목 목록
    /// </summary>
    protected void GetItemAdminList()
    {
        ReqItemAdminList                lo_objReqItemAdminList = null;
        ServiceResult<ResItemAdminList> lo_objResItemAdminList = null;

        try
        {
            lo_objReqItemAdminList = new ReqItemAdminList
            {   
                AdminID   = objSes.AdminID,
                GroupCode = strGroupCode,
                PageSize  = intPageSize,
                PageNo    = intPageNo
            };

            lo_objResItemAdminList = objItemDasServices.GetItemAdminList(lo_objReqItemAdminList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResItemAdminList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ItemAdminHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 사용자 항목 등록
    /// </summary>
    protected void SetItemAdminIns()
    {
        ItemAdminModel                lo_objItemAdminModel  = null;
        ServiceResult<ItemAdminModel> lo_objResItemAdminIns = null;
            
        if (string.IsNullOrWhiteSpace(strBookmarkFlag) || string.IsNullOrWhiteSpace(strItemFullCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strGroupCode = strGroupCode.ToUpper();

        try
        {
            lo_objItemAdminModel = new ItemAdminModel
            {
                AdminID      = objSes.AdminID,
                ItemFullCode = strItemFullCode,
                BookmarkFlag = strBookmarkFlag,
                AdminSort    = strAdminSort.ToInt(),
                RegAdminID   = objSes.AdminID
            };

            lo_objResItemAdminIns = objItemDasServices.SetItemAdminIns(lo_objItemAdminModel);
            objResMap.RetCode     = lo_objResItemAdminIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResItemAdminIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo",    lo_objResItemAdminIns.data.SeqNo);
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

    /// <summary>
    /// 항목 JSON 파일 생성
    /// </summary>
    protected void SetMakeItemJson()
    {
        ServiceResult<ResItemAdminList> lo_objResItemAdminList = null;
        string                          lo_strJson             = string.Empty;
        string                          lo_strJsonCache        = string.Empty;
        string                          lo_strFileName         = string.Empty;
        DataTable                       lo_objDataTable        = null;

        try
        {
            lo_objResItemAdminList = objItemDasServices.GetItemAdminListJson();
            lo_strJson             = JsonConvert.SerializeObject(lo_objResItemAdminList.data.list);
            
            lo_strFileName = CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST_JSON;
            File.WriteAllText(lo_strFileName, lo_strJson);

            lo_strJsonCache = CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST;
            if (null != objHttpContext.Cache[lo_strJsonCache])
            {
                objHttpContext.Cache.Remove(lo_strJsonCache);
            }
            
            lo_objDataTable = JsonConvert.DeserializeObject<DataTable>(lo_strJson);

            objHttpContext.Cache.Insert(lo_strJsonCache, lo_objDataTable, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);

            objResMap.RetCode = CommonConstant.DAS_SUCCESS_CODE;
            objResMap.ErrMsg  = "OK";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ItemHandler", "Exception",
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