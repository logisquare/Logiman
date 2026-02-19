<%@ WebHandler Language="C#" Class="SearchConditionAppHandler" %>
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using CommonLibrary.CommonModel;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;

public class SearchConditionAppHandler : AppAshxBaseHandler
{
    // 메소드 리스트
    private const string MethodSearchConditionUpd = "SearchConditionUpdate"; //검색조건 저장 
    private const string MethodSearchConditionGet = "SearchConditionGet"; //검색조건 조회

    private string strCallType = string.Empty;
    private string strCodeType = string.Empty;
    private string strCodes    = string.Empty;
    private string strCodeID   = string.Empty;

    AdminDasServices objAdminDasServices = new AdminDasServices();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    /// 
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        ///objMethodAuthList.Add(MethodSearchConditionUpd, MenuAuthType.ReadWrite);
        //objMethodAuthList.Add(MethodSearchConditionGet, MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        ///IgnoreCheckMenuAuth();

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

            SiteGlobal.WriteLog("SearchConditionAppHandler",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SearchConditionAppHandler");
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
            strCallType = SiteGlobal.GetRequestForm("CallType");
            strCodeType = Utils.IsNull(SiteGlobal.GetRequestForm("CodeType"), "0");
            strCodes    = SiteGlobal.GetRequestForm("Codes");
            strCodeID   = SiteGlobal.GetRequestForm("CodeID");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SearchConditionAppHandler",
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
                case MethodSearchConditionUpd:
                    SetSearchConditionUpd();
                    break;
                case MethodSearchConditionGet:
                    GetSearchCondition();
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

            SiteGlobal.WriteLog("SearchConditionAppHandler",
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
    /// 검색조건 저장
    /// </summary>
    protected void SetSearchConditionUpd()
    {
        AdminCodesModel     lo_objAdminCodesModel       = null;
        ServiceResult<bool> lo_objResUpdAdminCodes      = null;
        string              lo_strOrderLocationCodes    = string.Empty;
        string              lo_strOrderItemCodes        = string.Empty;
        string              lo_strOrderStatusCodes      = string.Empty;
        string              lo_strDeliveryLocationCodes = string.Empty;

        if (strCodeType.Equals("0") || string.IsNullOrWhiteSpace(strCodeType))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        lo_strOrderLocationCodes    = strCodeType.Equals("1") ? strCodes : objSes.OrderLocationCodes;
        lo_strOrderItemCodes        = strCodeType.Equals("2") ? strCodes : objSes.OrderItemCodes;
        lo_strOrderStatusCodes      = strCodeType.Equals("3") ? strCodes : objSes.OrderStatusCodes;
        lo_strDeliveryLocationCodes = strCodeType.Equals("4") ? strCodes : objSes.DeliveryLocationCodes;

        try
        {
            lo_objAdminCodesModel = new AdminCodesModel
            {
                AdminID               = objSes.AdminID,
                OrderLocationCodes    = lo_strOrderLocationCodes,
                OrderItemCodes        = lo_strOrderItemCodes,
                OrderStatusCodes      = lo_strOrderStatusCodes,
                DeliveryLocationCodes = lo_strDeliveryLocationCodes
            };

            lo_objResUpdAdminCodes = objAdminDasServices.SetUpdAdminCodes(lo_objAdminCodesModel);
            
            objResMap.RetCode = lo_objResUpdAdminCodes.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminCodes.result.ErrorMsg;
                return;
            }

            objSes.OrderLocationCodes    = lo_strOrderLocationCodes;
            objSes.OrderItemCodes        = lo_strOrderItemCodes;
            objSes.OrderStatusCodes      = lo_strOrderStatusCodes;
            objSes.DeliveryLocationCodes = lo_strDeliveryLocationCodes;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SearchConditionAppHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 검색조건 조회
    /// </summary>
    protected void GetSearchCondition()
    {
        string lo_strCodes = string.Empty;

        if (strCodeType.Equals("0") || string.IsNullOrWhiteSpace(strCodeType))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCodeID))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            switch (strCodeType)
            {
                case "1":
                    lo_strCodes = objSes.OrderLocationCodes;
                    break;
                case "2":
                    lo_strCodes = objSes.OrderItemCodes;
                    break;
                case "3":
                    lo_strCodes = objSes.OrderStatusCodes;
                    break;
                case "4":
                    lo_strCodes = objSes.DeliveryLocationCodes;
                    break;
            }

            objResMap.Add("Codes", lo_strCodes);
            objResMap.Add("CodeID", strCodeID);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SearchConditionAppHandler", "Exception",
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