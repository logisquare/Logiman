<%@ WebHandler Language="C#" Class="OrderCopyHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using System;
using System.Web;
using CommonLibrary.Extensions;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : OrderCopyHandler.ashx
/// Description     : 오더복사 Process Handler
/// Special Logicc
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemOrderCopyHandler
/// Author          : sybyun96@logislab.com, 2022-08-10
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderCopyHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/OrderCopy"; //필수

    // 메소드 리스트
    private const string MethodCalendarList          = "CalendarList";             //달력 검색
    private const string MethodDomesticOrderCopyIns  = "DomesticOrderCopyInsert";  //내수 오더 복사
    private const string MethodInoutOrderCopyIns     = "InoutOrderCopyInsert";     //수출입 오더 복사
    private const string MethodContainerOrderCopyIns = "ContainerOrderCopyInsert"; //컨테이너 오더 복사

    OrderDasServices  objOrderDasServices  = new OrderDasServices();

    private string strCallType          = string.Empty;
    private string strCenterCode        = string.Empty;
    private string strOrderNos          = string.Empty;
    private string strOrderCnt          = string.Empty;
    private string strPickupYMDs        = string.Empty;
    private string strGetYMDType        = string.Empty;
    private string strDispatchFlag      = string.Empty;
    private string strNoteFlag          = string.Empty;
    private string strNoteClientFlag    = string.Empty;
    private string strGoodsFlag         = string.Empty;
    private string strArrivalReportFlag = string.Empty;
    private string strCustomFlag        = string.Empty;
    private string strBondedFlag        = string.Empty;
    private string strInTimeFlag        = string.Empty;
    private string strQuickGetFlag      = string.Empty;
    private string strTaxChargeFlag     = string.Empty;
    
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCalendarList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticOrderCopyIns,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutOrderCopyIns,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerOrderCopyIns, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderCopyHandler");
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
            strOrderNos          = SiteGlobal.GetRequestForm("OrderNos");
            strPickupYMDs        = SiteGlobal.GetRequestForm("PickupYMDs");
            strCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),        "0");
            strOrderCnt          = Utils.IsNull(SiteGlobal.GetRequestForm("OrderCnt"),          "1");
            strGetYMDType        = Utils.IsNull(SiteGlobal.GetRequestForm("GetYMDType"),        "1");
            strNoteFlag          = Utils.IsNull(SiteGlobal.GetRequestForm("NoteFlag"),          "N");
            strNoteClientFlag    = Utils.IsNull(SiteGlobal.GetRequestForm("NoteClientFlag"),    "N");
            strDispatchFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchFlag"),      "N");
            strGoodsFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsFlag"),         "N");
            strArrivalReportFlag = Utils.IsNull(SiteGlobal.GetRequestForm("ArrivalReportFlag"), "N");
            strCustomFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("CustomFlag"),        "N");
            strBondedFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("BondedFlag"),        "N");
            strInTimeFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("InTimeFlag"),        "N");
            strQuickGetFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("QuickGetFlag"),      "N");
            strTaxChargeFlag     = Utils.IsNull(SiteGlobal.GetRequestForm("TaxChargeFlag"),      "N");
            
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
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
                case MethodCalendarList:
                    GetCalendarList();
                    break;
                case MethodDomesticOrderCopyIns:
                    SetDomesticOrderCopyIns();
                    break;
                case MethodInoutOrderCopyIns:
                    SetInoutOrderCopyIns();
                    break;
                case MethodContainerOrderCopyIns:
                    SetContainerOrderCopyIns();
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

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 캘린더 날짜 조회
    /// </summary>
    protected void GetCalendarList()
    {
        ServiceResult<ResOrderCopyCalendarList> lo_objResOrderCopyCalendarList = null;

        try
        {
            lo_objResOrderCopyCalendarList = objOrderDasServices.GetOrderCopyCalendarList();
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResOrderCopyCalendarList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 복사
    /// </summary>
    protected void SetDomesticOrderCopyIns()
    {
        ReqOrderCopyIns     lo_objReqOrderCopyIns = null;
        ServiceResult<bool> lo_objResOrderCopyIns = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMDs))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderCnt.Equals("0") || string.IsNullOrWhiteSpace(strOrderCnt))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGetYMDType.Equals("0") || string.IsNullOrWhiteSpace(strGetYMDType))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objReqOrderCopyIns = new ReqOrderCopyIns
            {
                CenterCode        = strCenterCode.ToInt(),
                OrderNos          = strOrderNos,
                OrderCnt          = strOrderCnt.ToInt(),
                PickupYMDs        = strPickupYMDs,
                GetYMDType        = strGetYMDType.ToInt(),
                NoteClientFlag    = strNoteClientFlag,
                NoteFlag          = strNoteFlag,
                GoodsFlag         = strGoodsFlag,
                DispatchFlag      = strDispatchFlag,
                AdminID           = objSes.AdminID,
                AdminName         = objSes.AdminName,
                AdminTeamCode     = string.Empty //★
            };

            lo_objResOrderCopyIns = objOrderDasServices.SetDomesticOrderCopyIns(lo_objReqOrderCopyIns);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderCopyIns) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 복사
    /// </summary>
    protected void SetInoutOrderCopyIns()
    {
        ReqOrderCopyIns     lo_objReqOrderCopyIns = null;
        ServiceResult<bool> lo_objResOrderCopyIns = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMDs))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderCnt.Equals("0") || string.IsNullOrWhiteSpace(strOrderCnt))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGetYMDType.Equals("0") || string.IsNullOrWhiteSpace(strGetYMDType))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objReqOrderCopyIns = new ReqOrderCopyIns
            {
                CenterCode        = strCenterCode.ToInt(),
                OrderNos          = strOrderNos,
                OrderCnt          = strOrderCnt.ToInt(),
                PickupYMDs        = strPickupYMDs,
                GetYMDType        = strGetYMDType.ToInt(),
                NoteClientFlag    = strNoteClientFlag,
                NoteFlag          = "Y", //strNoteFlag
                ArrivalReportFlag = strArrivalReportFlag,
                CustomFlag        = strCustomFlag,
                BondedFlag        = strBondedFlag,
                InTimeFlag        = "Y", //strInTimeFlag
                QuickGetFlag      = "Y", //strQuickGetFlag
                TaxChargeFlag     = strTaxChargeFlag,
                GoodsFlag         = strGoodsFlag,
                AdminID           = objSes.AdminID,
                AdminName         = objSes.AdminName,
                AdminTeamCode     = string.Empty //★
            };

            lo_objResOrderCopyIns = objOrderDasServices.SetInoutOrderCopyIns(lo_objReqOrderCopyIns);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderCopyIns) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 복사
    /// </summary>
    protected void SetContainerOrderCopyIns()
    {
        ReqOrderCopyIns     lo_objReqOrderCopyIns = null;
        ServiceResult<bool> lo_objResOrderCopyIns = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMDs))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderCnt.Equals("0") || string.IsNullOrWhiteSpace(strOrderCnt))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objReqOrderCopyIns = new ReqOrderCopyIns
            {
                CenterCode      = strCenterCode.ToInt(),
                OrderNos        = strOrderNos,
                OrderCnt        = strOrderCnt.ToInt(),
                PickupYMDs      = strPickupYMDs,
                NoteClientFlag  = strNoteClientFlag,
                NoteFlag        = "Y", //strNoteFlag
                GoodsFlag       = strGoodsFlag,
                AdminID         = objSes.AdminID,
                AdminName       = objSes.AdminName,
                AdminTeamCode   = string.Empty //★
            };

            lo_objResOrderCopyIns = objOrderDasServices.SetContainerOrderCopyIns(lo_objReqOrderCopyIns);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderCopyIns) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCopyHandler", "Exception",
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