<%@ WebHandler Language="C#" Class="OrderCargopassHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using System;
using System.Web;

///================================================================
/// <summary>
/// FileName        : OrderCargopassHandler.ashx
/// Description     : 카고패스 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-08-22
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderCargopassHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/OrderCargopassList"; //필수

    // 메소드 리스트
    private const string MethodCargopassList        = "CargopassList";        //카고패스 현황 조회
    private const string MethodCargopassDetail      = "CargopassDetail";      //카고패스 상세
    private const string MethodOrderPlaceList       = "OrderPlaceList";       //카고패스 연동 상하차정보 목록
    private const string MethodCargopassIns         = "CargopassInsert";      //연동정보 등록
    private const string MethodCargopassUpd         = "CargopassUpdate";      //연동정보 수정
    private const string MethodPlanYMD              = "PlanYMD";              //빠른입금 송금예정일
    private const string MethodCargopassSessionView = "CargopassSessionView"; //연동정보보기용 세션정보
    private const string MethodCargopassSessionList = "CargopassSessionList"; //연동현황용 세션정보

    CargopassDasSerivices objCargopassDasSerivices = new CargopassDasSerivices();
    OrderDasServices      objOrderDasServices      = new OrderDasServices();

    private HttpContext objHttpContext       = null;
    private string      strCallType          = string.Empty;
    private int         intPageSize          = 0;
    private int         intPageNo            = 0;
    private string      strCenterCode        = string.Empty;
    private string      strCenterName        = string.Empty;
    private string      strCargopassOrderNo  = string.Empty;
    private string      strDateType          = string.Empty;
    private string      strDateFrom          = string.Empty;
    private string      strDateTo            = string.Empty;
    private string      strComCorpNo         = string.Empty;
    private string      strCarNo             = string.Empty;
    private string      strDriverName        = string.Empty;
    private string      strDriverCell        = string.Empty;
    private string      strOrderNo           = string.Empty;
    private string      strCargopassStatuses = string.Empty;
    private string      strMyOrderFlag       = string.Empty;
    private string      strRegAdminName      = string.Empty;
    private string      strYMD               = string.Empty;
    private string      strAddDateCnt        = string.Empty;
    private string      strHolidayFlag       = string.Empty;
    private string      strOrderNos          = string.Empty;
    private string      strDispatchType      = string.Empty;
    private string      strConsignorName     = string.Empty;
    private string      strTelNo             = string.Empty;
    private string      strPickupYMD         = string.Empty;
    private string      strPickupHM          = string.Empty;
    private string      strPickupAddr        = string.Empty;
    private string      strPickupAddrDtl     = string.Empty;
    private string      strPickupWay         = string.Empty;
    private string      strGetYMD            = string.Empty;
    private string      strGetHM             = string.Empty;
    private string      strGetAddr           = string.Empty;
    private string      strGetAddrDtl        = string.Empty;
    private string      strGetWay            = string.Empty;
    private string      strGetTelNo          = string.Empty;
    private string      strCarTon            = string.Empty;
    private string      strCarTruck          = string.Empty;
    private string      strVolume            = string.Empty;
    private string      strCBM               = string.Empty;
    private string      strWeight            = string.Empty;
    private string      strSupplyAmt         = string.Empty;
    private string      strQuickType         = string.Empty;
    private string      strPayPlanYMD        = string.Empty;
    private string      strLayerFlag         = string.Empty;
    private string      strUrgentFlag        = string.Empty;
    private string      strShuttleFlag       = string.Empty;
    private string      strNote              = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCargopassList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCargopassDetail,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderPlaceList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCargopassIns,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCargopassUpd,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPlanYMD,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCargopassSessionView, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCargopassSessionList, MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderCargopassHandler");
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
            strCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strCenterName        = SiteGlobal.GetRequestForm("CenterName");
            strCargopassOrderNo  = Utils.IsNull(SiteGlobal.GetRequestForm("CargopassOrderNo"), "0");
            strDateType          = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),         "0");
            strDateFrom          = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo            = SiteGlobal.GetRequestForm("DateTo");
            strComCorpNo         = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo             = SiteGlobal.GetRequestForm("CarNo");
            strDriverName        = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell        = SiteGlobal.GetRequestForm("DriverCell");
            strOrderNo           = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strCargopassStatuses = SiteGlobal.GetRequestForm("CargopassStatuses");
            strMyOrderFlag       = SiteGlobal.GetRequestForm("MyOrderFlag");
            strRegAdminName      = SiteGlobal.GetRequestForm("RegAdminName");
            strOrderNos          = SiteGlobal.GetRequestForm("OrderNos");
            strYMD               = SiteGlobal.GetRequestForm("YMD");
            strAddDateCnt        = Utils.IsNull(SiteGlobal.GetRequestForm("AddDateCnt"), "0");
            strHolidayFlag       = SiteGlobal.GetRequestForm("HolidayFlag");
            strConsignorName     = SiteGlobal.GetRequestForm("ConsignorName");
            strDispatchType      = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchType"), "0");
            strTelNo             = SiteGlobal.GetRequestForm("TelNo");
            strPickupYMD         = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM          = SiteGlobal.GetRequestForm("PickupHM");
            strPickupAddr        = SiteGlobal.GetRequestForm("PickupAddr");
            strPickupAddrDtl     = SiteGlobal.GetRequestForm("PickupAddrDtl");
            strPickupWay         = SiteGlobal.GetRequestForm("PickupWay");
            strGetYMD            = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM             = SiteGlobal.GetRequestForm("GetHM");
            strGetAddr           = SiteGlobal.GetRequestForm("GetAddr");
            strGetAddrDtl        = SiteGlobal.GetRequestForm("GetAddrDtl");
            strGetWay            = SiteGlobal.GetRequestForm("GetWay");
            strGetTelNo          = SiteGlobal.GetRequestForm("GetTelNo");
            strCarTon            = SiteGlobal.GetRequestForm("CarTon");
            strCarTruck          = SiteGlobal.GetRequestForm("CarTruck");
            strVolume            = Utils.IsNull(SiteGlobal.GetRequestForm("Volume"),    "0");
            strCBM               = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"),       "0");
            strWeight            = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"),    "0");
            strSupplyAmt         = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"), "0");
            strQuickType         = Utils.IsNull(SiteGlobal.GetRequestForm("QuickType"), "0");
            strPayPlanYMD        = SiteGlobal.GetRequestForm("PayPlanYMD");
            strLayerFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("LayerFlag"),   "N");
            strUrgentFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("UrgentFlag"),  "N");
            strShuttleFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("ShuttleFlag"), "N");
            strNote              = SiteGlobal.GetRequestForm("Note");

            strDateFrom   = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo     = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);
            strPickupYMD  = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", string.Empty);
            strGetYMD     = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", string.Empty);
            strPayPlanYMD = string.IsNullOrWhiteSpace(strPayPlanYMD) ? strPayPlanYMD : strPayPlanYMD.Replace("-", string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
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
                case MethodCargopassList:
                    GetCargopassList();
                    break;
                case MethodCargopassDetail:
                    GetCargopassDetail();
                    break;
                case MethodOrderPlaceList:
                    GetOrderPlaceList();
                    break;
                case MethodCargopassIns:
                    SetCargopassIns();
                    break;
                case MethodCargopassUpd:
                    SetCargopassUpd();
                    break;
                case MethodPlanYMD:
                    GetPlanYMD();
                    break;
                case MethodCargopassSessionView:
                    GetCargopassSessionView();
                    break;
                case MethodCargopassSessionList:
                    GetCargopassSessionList();
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

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 카고패스 현황 조회
    /// </summary>
    protected void GetCargopassList()
    {
        ReqCargopassList                lo_objReqCargopassList = null;
        ServiceResult<ResCargopassList> lo_objResCargopassList = null;

        if (strCargopassOrderNo.Equals("0") && (strDateType.Equals("0") || string.IsNullOrWhiteSpace(strDateType) || string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //내오더 강제 적용
        strMyOrderFlag = "Y";

        try
        {
            lo_objReqCargopassList = new ReqCargopassList
            {
                CargopassOrderNo  = strCargopassOrderNo.ToInt64(),
                CenterCode        = strCenterCode.ToInt(),
                DateType          = strDateType.ToInt(),
                DateFrom          = strDateFrom,
                DateTo            = strDateTo,
                ComCorpNo         = strComCorpNo,
                CarNo             = strCarNo,
                DriverName        = strDriverName,
                DriverCell        = strDriverCell,
                OrderNo           = strOrderNo.ToInt64(),
                CargopassStatuses = strCargopassStatuses,
                MyOrderFlag       = strMyOrderFlag,
                RegAdminID        = objSes.AdminID,
                RegAdminName      = strRegAdminName,
                AccessCenterCode  = objSes.AccessCenterCode,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResCargopassList = objCargopassDasSerivices.GetCargopassList(lo_objReqCargopassList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCargopassList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 카고패스 상세
    /// </summary>
    protected void GetCargopassDetail()
    {
        ReqCargopassList                lo_objReqCargopassList = null;
        ServiceResult<ResCargopassList> lo_objResCargopassList = null;

        if (strCargopassOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCargopassList = new ReqCargopassList
            {
                CenterCode       = strCenterCode.ToInt(),
                CargopassOrderNo = strCargopassOrderNo.ToInt64(),
                RegAdminID       = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResCargopassList = objCargopassDasSerivices.GetCargopassList(lo_objReqCargopassList);

            if (!lo_objResCargopassList.data.RecordCnt.Equals(1))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "카고패스 연동정보가 없습니다.";
                return;
            }

            if (!lo_objResCargopassList.data.list[0].RegAdminID.Equals(objSes.AdminID))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "카고패스 연동정보를 볼 수 있는 권한이 없습니다.";
                return;
            }

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCargopassList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고패스 연동 상하차정보 목록
    /// </summary>
    protected void GetOrderPlaceList()
    {
        ReqCargopassOrderPlaceList                lo_objReqCargopassOrderPlaceList = null;
        ServiceResult<ResCargopassOrderPlaceList> lo_objResCargopassOrderPlaceList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if ((string.IsNullOrWhiteSpace(strCargopassOrderNo) || strCargopassOrderNo.Equals("0")) && string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCargopassOrderPlaceList = new ReqCargopassOrderPlaceList
            {
                CargopassOrderNo = strCargopassOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNos         = strOrderNos,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCargopassOrderPlaceList = objCargopassDasSerivices.GetCargopassOrderPlaceList(lo_objReqCargopassOrderPlaceList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCargopassOrderPlaceList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고패스 연동정보 등록
    /// </summary>
    protected void SetCargopassIns()
    {
        CargopassModel                lo_objReqCargopassIns   = null;
        ServiceResult<CargopassModel> lo_objResCargopassIns   = null;
        CenterSessionInfo             lo_objCenterSessionInfo = null;
        CenterOrderInfo               lo_objCenterOrderInfo   = null;
        string                        lo_strSessionKey        = string.Empty;
        string                        lo_strEncSession        = string.Empty;
        string                        lo_strOrderInfo         = string.Empty;
        string                        lo_strCargopassOrderNo  = string.Empty;

        if (string.IsNullOrWhiteSpace(objSes.Network24DDID) && string.IsNullOrWhiteSpace(objSes.NetworkHMMID) && string.IsNullOrWhiteSpace(objSes.NetworkOneCallID) && string.IsNullOrWhiteSpace(objSes.NetworkOneCallID) && string.IsNullOrWhiteSpace(objSes.NetworkHmadangID))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "내 정보 수정에서 정보망 아이디를 입력해야 연동이 가능합니다.";
            return;
        }

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

        if (strDispatchType.Equals("0") || string.IsNullOrWhiteSpace(strDispatchType))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupHM) || string.IsNullOrWhiteSpace(strPickupAddr) || string.IsNullOrWhiteSpace(strPickupAddrDtl) || string.IsNullOrWhiteSpace(strPickupAddr))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetHM) || string.IsNullOrWhiteSpace(strGetAddr) || string.IsNullOrWhiteSpace(strGetAddrDtl) || string.IsNullOrWhiteSpace(strGetAddr))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCargopassIns = new CargopassModel
            {
                CenterCode       = strCenterCode.ToInt(),
                DispatchType     = strDispatchType.ToInt(),
                OrderNos         = strOrderNos,
                ConsignorName    = strConsignorName,
                TelNo            = strTelNo,
                PickupYMD        = strPickupYMD,
                PickupHM         = strPickupHM,
                PickupAddrDtl    = strPickupAddrDtl,
                PickupAddr       = strPickupAddr,
                PickupWay        = strPickupWay,
                GetYMD           = strGetYMD,
                GetHM            = strGetHM,
                GetAddr          = strGetAddr,
                GetAddrDtl       = strGetAddrDtl,
                GetWay           = strGetWay,
                GetTelNo         = strGetTelNo,
                Volume           = strVolume.ToInt(),
                CBM              = strCBM.ToDouble(),
                Weight           = Math.Truncate(strWeight.ToDouble() * 100).ToDouble() / 100,
                CarTon           = strCarTon,
                CarTruck         = strCarTruck,
                QuickType        = strQuickType.ToInt(),
                PayPlanYMD       = strPayPlanYMD,
                SupplyAmt        = strSupplyAmt.ToDouble(),
                LayerFlag        = strLayerFlag,
                UrgentFlag       = strUrgentFlag,
                ShuttleFlag      = strShuttleFlag,
                Note             = strNote,
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                RegAdminID       = objSes.AdminID,
                RegAdminName     = objSes.AdminName
            };

            lo_objResCargopassIns = objCargopassDasSerivices.SetCargopassIns(lo_objReqCargopassIns);
            objResMap.RetCode     = lo_objResCargopassIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCargopassIns.result.ErrorMsg;
                return;
            }

            lo_strCargopassOrderNo = lo_objResCargopassIns.data.CargopassOrderNo.ToString();

            objResMap.Add("CargopassOrderNo", lo_strCargopassOrderNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9409;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objCenterSessionInfo = new CenterSessionInfo
            {
                SessionKey       = Utils.GetRandomNumber().ToString().Right(5),
                SiteCode         = CommonConstant.SITE_CODE,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                LoginIP          = SiteGlobal.GetRemoteAddr(),
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                MobileNo         = objSes.MobileNo,
                TelNo            = objSes.TelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            strSupplyAmt = !string.IsNullOrWhiteSpace(strSupplyAmt) ? strSupplyAmt.Replace(",", string.Empty) : "0";

            lo_objCenterOrderInfo = new CenterOrderInfo
            {
                SiteCode         = CommonConstant.SITE_CODE,
                CenterOrderNo    = lo_strCargopassOrderNo,
                CenterCode       = strCenterCode,
                CenterName       = strCenterName,
                ConsignorName    = strConsignorName,
                StartAddr        = strPickupAddr,
                StartDetail      = strPickupAddrDtl,
                EndAddr          = strGetAddr,
                EndDetail        = strGetAddrDtl,
                MultiCargoGub    = strLayerFlag.Equals("Y") ? "혼적" : "독차",
                Urgent           = strUrgentFlag.Equals("Y") ? "긴급" : "일반",
                ShuttleCargoInfo = strShuttleFlag.Equals("Y") ? "왕복" : "편도",
                CargoTon         = strCarTon,
                TruckType        = strCarTruck,
                FrgTon           = (Math.Truncate(strWeight.ToDouble() * 100).ToDouble() / 100).ToString(),
                StartPlanDT      = strPickupYMD,
                StartPlanTm      = strPickupHM,
                EndPlanDT        = strGetYMD,
                EndPlanTm        = strGetHM,
                StartLoad        = strPickupWay,
                EndLoad          = strGetWay,
                EndAreaPhone     = strGetTelNo,
                CargoDsc         = strNote,
                Fare             = strSupplyAmt,
                PayPlanYmd       = strPayPlanYMD,
                Telephone        = strTelNo,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            lo_strSessionKey = lo_objCenterSessionInfo.SessionKey;
            lo_strEncSession = Utils.GetEncrypt4Cargopass(JsonConvert.SerializeObject(lo_objCenterSessionInfo), lo_strSessionKey);
            lo_strOrderInfo  = JsonConvert.SerializeObject(lo_objCenterOrderInfo);

            objResMap.Add("SessionKey", lo_strSessionKey);
            objResMap.Add("EncSession", HttpUtility.UrlEncode(lo_strEncSession));
            objResMap.Add("OrderInfo",  lo_strOrderInfo);
            objResMap.Add("InsUrl",     SiteGlobal.CARGOPASS_INS_URL);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고패스 연동정보 수정
    /// </summary>
    protected void SetCargopassUpd()
    {
        CargopassModel                lo_objReqCargopassUpd   = null;
        ServiceResult<CargopassModel> lo_objResCargopassUpd   = null;
        CenterSessionInfo             lo_objCenterSessionInfo = null;
        CenterOrderInfo               lo_objCenterOrderInfo   = null;
        string                        lo_strSessionKey        = string.Empty;
        string                        lo_strEncSession        = string.Empty;
        string                        lo_strOrderInfo         = string.Empty;

        if (string.IsNullOrWhiteSpace(objSes.Network24DDID) && string.IsNullOrWhiteSpace(objSes.NetworkHMMID) && string.IsNullOrWhiteSpace(objSes.NetworkOneCallID) && string.IsNullOrWhiteSpace(objSes.NetworkHmadangID))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "내 정보 수정에서 정보망 아이디를 입력해야 연동이 가능합니다.";
            return;
        }

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strCargopassOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strCargopassOrderNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strDispatchType.Equals("0") || string.IsNullOrWhiteSpace(strDispatchType))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupHM) || string.IsNullOrWhiteSpace(strPickupAddr) || string.IsNullOrWhiteSpace(strPickupAddrDtl) || string.IsNullOrWhiteSpace(strPickupAddr))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetHM) || string.IsNullOrWhiteSpace(strGetAddr) || string.IsNullOrWhiteSpace(strGetAddrDtl) || string.IsNullOrWhiteSpace(strGetAddr))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCargopassUpd = new CargopassModel
            {
                CargopassOrderNo = strCargopassOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DispatchType     = strDispatchType.ToInt(),
                ConsignorName    = strConsignorName,
                TelNo            = strTelNo,
                PickupYMD        = strPickupYMD,
                PickupHM         = strPickupHM,
                PickupAddr       = strPickupAddr,
                PickupAddrDtl    = strPickupAddrDtl,
                PickupWay        = strPickupWay,
                GetYMD           = strGetYMD,
                GetHM            = strGetHM,
                GetAddr          = strGetAddr,
                GetAddrDtl       = strGetAddrDtl,
                GetWay           = strGetWay,
                GetTelNo         = strGetTelNo,
                Volume           = strVolume.ToInt(),
                CBM              = strCBM.ToDouble(),
                Weight           = Math.Truncate(strWeight.ToDouble() * 100).ToDouble() / 100,
                CarTon           = strCarTon,
                CarTruck         = strCarTruck,
                QuickType        = strQuickType.ToInt(),
                PayPlanYMD       = strPayPlanYMD,
                SupplyAmt        = strSupplyAmt.ToDouble(),
                LayerFlag        = strLayerFlag,
                UrgentFlag       = strUrgentFlag,
                ShuttleFlag      = strShuttleFlag,
                Note             = strNote,
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                UpdAdminID       = objSes.AdminID,
                UpdAdminName     = objSes.AdminName
            };

            lo_objResCargopassUpd = objCargopassDasSerivices.SetCargopassUpd(lo_objReqCargopassUpd);
            objResMap.RetCode     = lo_objResCargopassUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCargopassUpd.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objCenterSessionInfo = new CenterSessionInfo
            {
                SessionKey       = Utils.GetRandomNumber().ToString().Right(5),
                SiteCode         = CommonConstant.SITE_CODE,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                LoginIP          = SiteGlobal.GetRemoteAddr(),
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                MobileNo         = objSes.MobileNo,
                TelNo            = objSes.TelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            strSupplyAmt = !string.IsNullOrWhiteSpace(strSupplyAmt) ? strSupplyAmt.Replace(",", string.Empty) : "0";

            lo_objCenterOrderInfo = new CenterOrderInfo
            {
                SiteCode         = CommonConstant.SITE_CODE,
                CenterOrderNo    = strCargopassOrderNo,
                CenterCode       = strCenterCode,
                CenterName       = strCenterName,
                ConsignorName    = strConsignorName,
                StartAddr        = strPickupAddr,
                StartDetail      = strPickupAddrDtl,
                EndAddr          = strGetAddr,
                EndDetail        = strGetAddrDtl,
                MultiCargoGub    = strLayerFlag.Equals("Y") ? "혼적" : "독차",
                Urgent           = strUrgentFlag.Equals("Y") ? "긴급" : "일반",
                ShuttleCargoInfo = strShuttleFlag.Equals("Y") ? "왕복" : "편도",
                CargoTon         = strCarTon,
                TruckType        = strCarTruck,
                FrgTon           = (Math.Truncate(strWeight.ToDouble() * 100).ToDouble() / 100).ToString(),
                StartPlanDT      = strPickupYMD,
                StartPlanTm      = strPickupHM,
                EndPlanDT        = strGetYMD,
                EndPlanTm        = strGetHM,
                StartLoad        = strPickupWay,
                EndLoad          = strGetWay,
                EndAreaPhone     = strGetTelNo,
                CargoDsc         = strNote,
                Fare             = strSupplyAmt,
                PayPlanYmd       = strPayPlanYMD,
                Telephone        = strTelNo,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            lo_strSessionKey = lo_objCenterSessionInfo.SessionKey;
            lo_strEncSession = Utils.GetEncrypt4Cargopass(JsonConvert.SerializeObject(lo_objCenterSessionInfo), lo_strSessionKey);
            lo_strOrderInfo  = JsonConvert.SerializeObject(lo_objCenterOrderInfo);

            objResMap.Add("SessionKey", lo_strSessionKey);
            objResMap.Add("EncSession", HttpUtility.UrlEncode(lo_strEncSession));
            objResMap.Add("OrderInfo",  lo_strOrderInfo);
            objResMap.Add("InsUrl",     SiteGlobal.CARGOPASS_INS_URL);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 빠른입금 송금예정일
    /// </summary>
    protected void GetPlanYMD()
    {
        ReqPlanYMDGet                lo_objReqPlanYMDGet = null;
        ServiceResult<ResPlanYMDGet> lo_objResPlanYMDGet = null;

        strAddDateCnt = Utils.IsNull(strAddDateCnt, "0");
        strYMD        = string.IsNullOrWhiteSpace(strYMD) ? strYMD : strYMD.Replace("-", "");

        if (string.IsNullOrWhiteSpace(strYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strAddDateCnt.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPlanYMDGet = new ReqPlanYMDGet
            {
                YMD         = strYMD,
                AddDateCnt  = strAddDateCnt.ToInt(),
                HolidayFlag = strHolidayFlag
            };

            lo_objResPlanYMDGet = objOrderDasServices.GetPlanYMD(lo_objReqPlanYMDGet);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResPlanYMDGet) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    //연동정보 조회용 세션
    protected void GetCargopassSessionView()
    {
        CenterSessionInfo lo_objCenterSessionInfo = null;
        CenterOrderInfo   lo_objCenterOrderInfo   = null;
        string            lo_strSessionKey        = string.Empty;
        string            lo_strEncSession        = string.Empty;
        string            lo_strOrderInfo         = string.Empty;

        try
        {
            lo_objCenterSessionInfo = new CenterSessionInfo
            {
                SessionKey       = Utils.GetRandomNumber().ToString().Right(5),
                SiteCode         = CommonConstant.SITE_CODE,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                LoginIP          = SiteGlobal.GetRemoteAddr(),
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                MobileNo         = objSes.MobileNo,
                TelNo            = objSes.TelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            lo_objCenterOrderInfo = new CenterOrderInfo
            {
                ViewFlag         = "Y",
                SiteCode         = CommonConstant.SITE_CODE,
                CenterOrderNo    = strCargopassOrderNo,
                CenterCode       = strCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            lo_strSessionKey = lo_objCenterSessionInfo.SessionKey;
            lo_strEncSession = Utils.GetEncrypt4Cargopass(JsonConvert.SerializeObject(lo_objCenterSessionInfo), lo_strSessionKey);
            lo_strOrderInfo  = JsonConvert.SerializeObject(lo_objCenterOrderInfo);

            objResMap.Add("SessionKey", lo_strSessionKey);
            objResMap.Add("EncSession", HttpUtility.UrlEncode(lo_strEncSession));
            objResMap.Add("OrderInfo",  lo_strOrderInfo);
            objResMap.Add("InsUrl",     SiteGlobal.CARGOPASS_INS_URL);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    //연동현황용 세션정보
    protected void GetCargopassSessionList()
    {
        CenterSessionInfo lo_objCenterSessionInfo = null;
        CenterOrderInfo   lo_objCenterOrderInfo   = null;
        string            lo_strSessionKey        = string.Empty;
        string            lo_strEncSession        = string.Empty;

        try
        {
            lo_objCenterSessionInfo = new CenterSessionInfo
            {
                SessionKey       = Utils.GetRandomNumber().ToString().Right(5),
                SiteCode         = CommonConstant.SITE_CODE,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                LoginIP          = SiteGlobal.GetRemoteAddr(),
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                MobileNo         = objSes.MobileNo,
                TelNo            = objSes.TelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };
                
            lo_strSessionKey = lo_objCenterSessionInfo.SessionKey;
            lo_strEncSession = Utils.GetEncrypt4Cargopass(JsonConvert.SerializeObject(lo_objCenterSessionInfo), lo_strSessionKey);
                
            objResMap.Add("SessionKey", lo_strSessionKey);
            objResMap.Add("EncSession", HttpUtility.UrlEncode(lo_strEncSession));
            objResMap.Add("ListURL",    SiteGlobal.CARGOPASS_LIST_URL);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderCargopassExtHandler", "Exception",
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