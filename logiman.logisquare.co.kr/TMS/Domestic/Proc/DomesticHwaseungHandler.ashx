<%@ WebHandler Language="C#" Class="DomesticHwaseungHandler" %>
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
/// FileName        : DomesticHwaseungHandler.ashx
/// Description     : 내수 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-09-19
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DomesticHwaseungHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Domestic/DomesticHwaseungIns"; //필수

    // 메소드 리스트
    private const string MethodOrderChk      = "OrderChk";    //오더 체크
    private const string MethodOrderIns      = "OrderInsert"; //오더 등록
    private const string MethodSearchCarList = "SearchCar";   //차량 검색

    OrderDasServices       objOrderDasServices       = new OrderDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private HttpContext          objHttpContext                  = null;

    private string strCallType                 = string.Empty;
    private int    intPageSize                 = 0;
    private int    intPageNo                   = 0;
    private string strCenterCode               = string.Empty;
    private string strOrderClientCode          = string.Empty;
    private string strOrderClientName          = string.Empty;
    private string strPayClientCode            = string.Empty;
    private string strPayClientName            = string.Empty;
    private string strConsignorCode            = string.Empty;
    private string strConsignorName            = string.Empty;
    private string strDeliveryType             = string.Empty;
    private string strPickupYMD                = string.Empty;
    private string strPickupPlace              = string.Empty;
    private string strPickupPlaceSeqNo         = string.Empty;
    private string strGetYMD                   = string.Empty;
    private string strGetPlace                 = string.Empty;
    private string strGetPlaceSeqNo            = string.Empty;
    private string strNoteInside               = string.Empty;
    private string strCarNo                    = string.Empty;
    private string strDriverName               = string.Empty;
    private string strDriverCell               = string.Empty;
    private string strRefSeqNo                 = string.Empty;
    private string strCarTonCode               = string.Empty;
    private string strCarTon                   = string.Empty; 
    private string strSaleAmt                  = string.Empty;
    private string strSaleLayoverAmt           = string.Empty;
    private string strSaleWaitingAmt           = string.Empty;
    private string strSaleWorkingAmt           = string.Empty;
    private string strSaleAreaAmt              = string.Empty;
    private string strSaleOilDifferenceAmt     = string.Empty;
    private string strPurchaseAmt              = string.Empty;
    private string strPurchaseLayoverAmt       = string.Empty;
    private string strPurchaseWaitingAmt       = string.Empty;
    private string strPurchaseConservationAmt  = string.Empty;
    private string strPurchaseOilAmt           = string.Empty;
    private string strPurchaseAreaAmt          = string.Empty;
    private string strPurchaseOilDifferenceAmt = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderChk,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderIns,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSearchCarList, MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DomesticHwaseungHandler");
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
            strCenterCode               = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),      "0");
            strOrderClientCode          = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"), "0");
            strOrderClientName          = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientCode            = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strPayClientName            = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorCode            = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strDeliveryType             = SiteGlobal.GetRequestForm("DeliveryType");
            strConsignorName            = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupYMD                = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupPlace              = SiteGlobal.GetRequestForm("PickupPlace");
            strPickupPlaceSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("PickupPlaceSeqNo"), "0");
            strGetYMD                   = SiteGlobal.GetRequestForm("GetYMD");
            strGetPlace                 = SiteGlobal.GetRequestForm("GetPlace");
            strGetPlaceSeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("GetPlaceSeqNo"), "0");
            strNoteInside               = SiteGlobal.GetRequestForm("NoteInside", false);
            strCarNo                    = SiteGlobal.GetRequestForm("CarNo");
            strDriverName               = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell               = SiteGlobal.GetRequestForm("DriverCell");
            strRefSeqNo                 = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"), "0");
            strCarTonCode               = SiteGlobal.GetRequestForm("CarTonCode");
            strCarTon                   = SiteGlobal.GetRequestForm("CarTon");
            strSaleAmt                  = Utils.IsNull(SiteGlobal.GetRequestForm("SaleAmt"),                  "0");
            strSaleLayoverAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("SaleLayoverAmt"),           "0");
            strSaleWaitingAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("SaleWaitingAmt"),           "0");
            strSaleWorkingAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("SaleWorkingAmt"),           "0");
            strSaleAreaAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("SaleAreaAmt"),              "0");
            strSaleOilDifferenceAmt     = Utils.IsNull(SiteGlobal.GetRequestForm("SaleOilDifferenceAmt"),     "0");
            strPurchaseAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseAmt"),              "0");
            strPurchaseLayoverAmt       = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseLayoverAmt"),       "0");
            strPurchaseWaitingAmt       = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseWaitingAmt"),       "0");
            strPurchaseConservationAmt  = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseConservationAmt"),  "0");
            strPurchaseOilAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOilAmt"),           "0");
            strPurchaseAreaAmt          = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseAreaAmt"),          "0");
            strPurchaseOilDifferenceAmt = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOilDifferenceAmt"), "0");

            strPickupYMD = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-",  string.Empty);
            strGetYMD    = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", string.Empty);
            strDriverCell    = string.IsNullOrWhiteSpace(strDriverCell) ? strDriverCell : strDriverCell.Replace("-", string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
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
                case MethodOrderChk:
                    GetOrderChk();
                    break;
                case MethodOrderIns:
                    SetOrderIns();
                    break;
                case MethodSearchCarList:
                    GetSearchCarList();
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

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process


    /// <summary>
    /// 오더 체크
    /// </summary>
    protected void GetOrderChk()
    {
        ReqOrderHwaseungChk                lo_objReqOrderHwaseungChk = null;
        ServiceResult<ResOrderHwaseungChk> lo_objResOrderHwaseungChk = null;
        string                             lo_strPickupPlace         = "양산 화승R&A"; //상차지명 고정

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDeliveryType) || (!strDeliveryType.Equals("정규") && !strDeliveryType.Equals("용차")))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarTon))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverName) || string.IsNullOrWhiteSpace(strDriverCell))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderHwaseungChk = new ReqOrderHwaseungChk
            {
                CenterCode    = strCenterCode.ToInt(),
                ConsignorName = strConsignorName,
                DeliveryType  = strDeliveryType,
                PickupYMD     = strPickupYMD,
                PickupPlace   = lo_strPickupPlace,
                GetPlace      = strGetPlace,
                CarTon        = strCarTon,
                CarNo         = strCarNo,
                DriverName    = strDriverName,
                DriverCell    = strDriverCell,
                RefSeqNo      = strRefSeqNo.ToInt64(),
                AdminID       = objSes.AdminID
            };

            lo_objResOrderHwaseungChk = objOrderDasServices.GetOrderHwaseungChk(lo_objReqOrderHwaseungChk);
            
            objResMap.RetCode = lo_objResOrderHwaseungChk.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderHwaseungChk.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("CenterFlag",       lo_objResOrderHwaseungChk.data.CenterFlag);
            objResMap.Add("CenterCode",       lo_objResOrderHwaseungChk.data.CenterCode);
            objResMap.Add("AuthFlag",         lo_objResOrderHwaseungChk.data.AuthFlag);
            objResMap.Add("ClientFlag",       lo_objResOrderHwaseungChk.data.ClientFlag);
            objResMap.Add("ClientCode",       lo_objResOrderHwaseungChk.data.ClientCode);
            objResMap.Add("PickupYMDFlag",    lo_objResOrderHwaseungChk.data.PickupYMDFlag);
            objResMap.Add("ConsignorFlag",    lo_objResOrderHwaseungChk.data.ConsignorFlag);
            objResMap.Add("ConsignorCode",    lo_objResOrderHwaseungChk.data.ConsignorCode);
            objResMap.Add("PickupPlaceFlag",  lo_objResOrderHwaseungChk.data.PickupPlaceFlag);
            objResMap.Add("PickupPlaceSeqNo", lo_objResOrderHwaseungChk.data.PickupPlaceSeqNo);
            objResMap.Add("GetPlaceFlag",     lo_objResOrderHwaseungChk.data.GetPlaceFlag);
            objResMap.Add("GetPlaceSeqNo",    lo_objResOrderHwaseungChk.data.GetPlaceSeqNo);
            objResMap.Add("CarTonFlag",       lo_objResOrderHwaseungChk.data.CarTonFlag);
            objResMap.Add("CarTonCode",       lo_objResOrderHwaseungChk.data.CarTonCode);
            objResMap.Add("CarFlag",          lo_objResOrderHwaseungChk.data.CarFlag);
            objResMap.Add("CarCnt",           lo_objResOrderHwaseungChk.data.CarCnt);
            objResMap.Add("RefSeqNo",         lo_objResOrderHwaseungChk.data.RefSeqNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }


    /// <summary>
    /// 오더 등록
    /// </summary>
    protected void SetOrderIns()
    {
        ReqOrderHwaseungIns                lo_objReqOrderHwaseungIns = null;
        ServiceResult<ResOrderHwaseungIns> lo_objResOrderHwaseungIns = null;
        
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderClientCode) || strOrderClientCode.Equals("0") || string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDeliveryType) || (!strDeliveryType.Equals("정규") && !strDeliveryType.Equals("용차")))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlaceSeqNo) || strPickupPlaceSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlaceSeqNo) || strGetPlaceSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strCarTonCode))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderHwaseungIns = new ReqOrderHwaseungIns
            {
                CenterCode               = strCenterCode.ToInt(),
                OrderClientCode          = strOrderClientCode.ToInt64(),
                PayClientCode            = strPayClientCode.ToInt64(),
                ConsignorCode            = strConsignorCode.ToInt64(),
                DeliveryType             = strDeliveryType,
                PickupYMD                = strPickupYMD,
                PickupPlaceSeqNo         = strPickupPlaceSeqNo.ToInt64(),
                GetYMD                   = strGetYMD,
                GetPlaceSeqNo            = strGetPlaceSeqNo.ToInt64(),
                NoteInside               = strNoteInside,
                CarTonCode               = strCarTonCode,
                RefSeqNo                 = strRefSeqNo.ToInt64(),
                SaleAmt                  = strSaleAmt.ToDouble(),
                SaleLayoverAmt           = strSaleLayoverAmt.ToDouble(),
                SaleWaitingAmt           = strSaleWaitingAmt.ToDouble(),
                SaleWorkingAmt           = strSaleWorkingAmt.ToDouble(),
                SaleAreaAmt              = strSaleAreaAmt.ToDouble(),
                SaleOilDifferenceAmt     = strSaleOilDifferenceAmt.ToDouble(),
                PurchaseAmt              = strPurchaseAmt.ToDouble(),
                PurchaseLayoverAmt       = strPurchaseLayoverAmt.ToDouble(),
                PurchaseWaitingAmt       = strPurchaseWaitingAmt.ToDouble(),
                PurchaseConservationAmt  = strPurchaseConservationAmt.ToDouble(),
                PurchaseOilAmt           = strPurchaseOilAmt.ToDouble(),
                PurchaseAreaAmt          = strPurchaseAreaAmt.ToDouble(),
                PurchaseOilDifferenceAmt = strPurchaseOilDifferenceAmt.ToDouble(),
                RegAdminID               = objSes.AdminID,
                RegAdminName             = objSes.AdminName
            };

            lo_objResOrderHwaseungIns = objOrderDasServices.SetOrderHwaseungIns(lo_objReqOrderHwaseungIns);
            
            objResMap.RetCode = lo_objResOrderHwaseungIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderHwaseungIns.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("OrderNo",       lo_objResOrderHwaseungIns.data.OrderNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 검색
    /// </summary>
    protected void GetSearchCarList()
    {
        ReqCarDispatchRefSearchList                lo_objReqCarDispatchRefSearchList = null;
        ServiceResult<ResCarDispatchRefSearchList> lo_objResCarDispatchRefSearchList = null;
        string                                     lo_strCarDivTypes                 = "3,6"; //단기, 고정

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDispatchRefSearchList = new ReqCarDispatchRefSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CarNo            = strCarNo,
                CarDivTypes      = lo_strCarDivTypes,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResCarDispatchRefSearchList = objCarDispatchDasServices.GetCarDispatchRefSearchList(lo_objReqCarDispatchRefSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchRefSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHwaseungHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    #endregion

    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
            // ignored
        }
    }
}