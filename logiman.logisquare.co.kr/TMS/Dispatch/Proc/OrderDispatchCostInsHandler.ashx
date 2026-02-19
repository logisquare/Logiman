<%@ WebHandler Language="C#" Class="OrderDispatchCostInsHandler" %>
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
/// FileName        : OrderDispatchCostInsHandler.ashx
/// Description     : 배차현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-05-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderDispatchCostInsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Dispatch/OrderDispatchCostIns"; //필수

    // 메소드 리스트
    private const string MethodOrderDispatchPayList    = "OrderDispatchPayList";    //비용등록 리스트
    private const string MethodOrderDispatchPayInsert  = "OrderDispatchPayInsert";  //비용등록
    private const string MethodOrderDispatchPayUpdate  = "OrderDispatchPayUpdate";  //비용수정
    private const string MethodTransRateOrderList      = "TransRateOrderList";      //요율표 조회(적용후)
    private const string MethodTransRateOrderApplyList = "TransRateOrderApplyList"; //요율표 조회
    private const string MethodAmtRequestOrderList     = "AmtRequestOrderList";     //요청 목록
    private const string MethodAmtRequestIns           = "AmtRequestInsert";        //요청 등록
    private const string MethodAmtRequestCnl           = "AmtRequestCancel";        //요청 삭제

        
    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();
    OrderDasServices         objOrderDasServices         = new OrderDasServices();

    private HttpContext objHttpContext = null;

    private string strCallType            = string.Empty;
    private int    intPageSize            = 0;
    private int    intPageNo              = 0;
    private string strCenterCode          = string.Empty;
    private string strDateType            = string.Empty;
    private string strDateFrom            = string.Empty;
    private string strDateTo              = string.Empty;
    private string strOrderLocationCodes  = string.Empty;
    private string strOrderItemCodes      = string.Empty;
    private string strOrderNo             = string.Empty;
    private string strClientCode          = string.Empty;
    private string strCarNo               = string.Empty;
    private string strComName             = string.Empty;
    private string strGoodsDispatchType   = string.Empty;
    private string strPurchaseItemCode    = string.Empty;
    private string strPurchaseSeqNo       = string.Empty;
    private string strGoodsSeqNo          = string.Empty;
    private string strDispatchSeqNo       = string.Empty;
    private string strPayType             = string.Empty;
    private string strTaxKind             = string.Empty;
    private string strItemCode            = string.Empty;
    private string strClientName          = string.Empty;
    private string strSupplyAmt           = string.Empty;
    private string strTaxAmt              = string.Empty;
    private string strListType            = string.Empty;
    private string strPayClientCode       = string.Empty;
    private string strConsignorCode       = string.Empty;
    private string strOrderItemCode       = string.Empty;
    private string strOrderLocationCode   = string.Empty;
    private string strFTLFlag             = string.Empty;
    private string strCarTonCode          = string.Empty;
    private string strCarTypeCode         = string.Empty;
    private string strPickupYMD           = string.Empty;
    private string strPickupHM            = string.Empty;
    private string strPickupPlaceFullAddr = string.Empty;
    private string strGetYMD              = string.Empty;
    private string strGetHM               = string.Empty;
    private string strGetPlaceFullAddr    = string.Empty;
    private string strSeqNo               = string.Empty;
    private string strReqKind             = string.Empty;
    private string strPaySeqNo            = string.Empty;
    private string strReqSupplyAmt        = string.Empty;
    private string strReqTaxAmt           = string.Empty;
    private string strReqReason           = string.Empty;
    private string strVolume              = string.Empty;
    private string strCBM                 = string.Empty;
    private string strWeight              = string.Empty;
    private string strLength              = string.Empty;
    private string strCarFixedFlag        = string.Empty;
    private string strApplySeqNo          = string.Empty;
    private string strTransDtlSeqNo       = string.Empty;
    private string strTransRateStatus     = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderDispatchPayList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderDispatchPayInsert,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderDispatchPayUpdate,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateOrderList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateOrderApplyList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestOrderList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestIns,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAmtRequestCnl,           MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderDispatchCostInsHandler");
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
            strCenterCode          = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo             = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strClientCode          = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strDateType            = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom            = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo              = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes  = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes      = SiteGlobal.GetRequestForm("OrderItemCodes");
            strCarNo               = SiteGlobal.GetRequestForm("CarNo");
            strComName             = SiteGlobal.GetRequestForm("ComName");
            strGoodsDispatchType   = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsDispatchType"), "0");
            strPurchaseItemCode    = SiteGlobal.GetRequestForm("PurchaseItemCode");
            strPurchaseSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseSeqNo"), "0");
            strGoodsSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPayType             = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind             = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode            = SiteGlobal.GetRequestForm("ItemCode");
            strClientName          = SiteGlobal.GetRequestForm("ClientName");
            strSupplyAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),     "0");
            strTaxAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),        "0");
            strListType            = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"),      "0");strPayClientCode = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strConsignorCode       = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strOrderItemCode       = SiteGlobal.GetRequestForm("OrderItemCode");
            strOrderLocationCode   = SiteGlobal.GetRequestForm("OrderLocationCode");
            strFTLFlag             = SiteGlobal.GetRequestForm("FTLFlag");
            strCarTonCode          = SiteGlobal.GetRequestForm("CarTonCode");
            strCarTypeCode         = SiteGlobal.GetRequestForm("CarTypeCode");
            strPickupYMD           = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM            = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlaceFullAddr = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strGetYMD              = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM               = SiteGlobal.GetRequestForm("GetHM");
            strGetPlaceFullAddr    = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strSeqNo               = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),        "0");
            strReqKind             = Utils.IsNull(SiteGlobal.GetRequestForm("ReqKind"),      "0");
            strPaySeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("PaySeqNo"),     "0");
            strReqSupplyAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSupplyAmt"), "0");
            strReqTaxAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("ReqTaxAmt"),    "0");
            strReqReason           = SiteGlobal.GetRequestForm("ReqReason");
            strVolume              = Utils.IsNull(SiteGlobal.GetRequestForm("Volume"), "0");
            strCBM                 = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"),    "0");
            strWeight              = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"), "0");
            strLength              = Utils.IsNull(SiteGlobal.GetRequestForm("Length"), "0");
            strCarFixedFlag        = SiteGlobal.GetRequestForm("CarFixedFlag");
            strApplySeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"),    "0");
            strTransDtlSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("TransDtlSeqNo"), "0");
            strTransRateStatus     = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateStatus"), "0");
                
            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
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
                case MethodOrderDispatchPayList:
                    GetOrderDispatchPayList();
                    break;
                case MethodOrderDispatchPayInsert:
                    GetOrderDispatchPayInsert();
                    break;
                case MethodOrderDispatchPayUpdate:
                    GetOrderDispatchPayUpdate();
                    break;   
                case MethodTransRateOrderList:
                    GetTransRateOrderList();
                    break;
                case MethodTransRateOrderApplyList:
                    GetTransRateOrderApplyList();
                    break;
                case MethodAmtRequestOrderList:
                    GetAmtRequestOrderList();
                    break;
                case MethodAmtRequestIns:
                    SetAmtRequestIns();
                    break;
                case MethodAmtRequestCnl:
                    SetAmtRequestCnl();
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

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 배차현황 비용 목록
    /// </summary>
    protected void GetOrderDispatchPayList()
    {

        ReqOrderDispatchList                   lo_objReqOrderDispatchPayList = null;
        ServiceResult<ResOrderDispatchPayList> lo_objResOrderDispatchPayList = null;

        try
        {
            lo_objReqOrderDispatchPayList = new ReqOrderDispatchList
            {
                OrderNo            = strOrderNo.ToInt64(),
                CenterCode         = strCenterCode.ToInt(),
                ListType           = strListType.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                GoodsDispatchType  = strGoodsDispatchType.ToInt(),
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                ComName            = strComName,
                CarNo              = strCarNo,
                PurchaseItemCode   = strPurchaseItemCode,
                AccessCenterCode   = objSes.AccessCenterCode,
                CnlFlag            = "N",
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResOrderDispatchPayList = objOrderDispatchDasServices.GetOrderDispatchPayList(lo_objReqOrderDispatchPayList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchPayInsert()
    {
        OrderPayModel                lo_objOrderPayModel  = null;
        ServiceResult<OrderPayModel> lo_objResOrderPayIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!string.IsNullOrWhiteSpace(strPurchaseSeqNo) && !strPurchaseSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "등록할 수 있는 비용이 아닙니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayType) || strPayType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxKind) || strTaxKind.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCode))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strPayType.Equals("2") || strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objOrderPayModel = new OrderPayModel
            {
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                GoodsSeqNo      = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo   = strDispatchSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };
                
            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayIns(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayIns.result.ErrorCode;
                
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("PurchaseSeqNo", lo_objResOrderPayIns.data.SeqNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchPayUpdate()
    {
        OrderPayModel       lo_objOrderPayModel  = null;
        ServiceResult<bool> lo_objResOrderPayIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseSeqNo) && strPurchaseSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayType) || strPayType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxKind) || strTaxKind.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCode))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strPayType.Equals("2") || strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objOrderPayModel = new OrderPayModel
            {
                SeqNo           = strPurchaseSeqNo.ToInt(),
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                GoodsSeqNo      = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo   = strDispatchSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                UpdAdminID      = objSes.AdminID,
                UpdAdminName    = objSes.AdminName
            };
                
            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayUpd(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 조회(적용후)
    /// </summary>
    protected void GetTransRateOrderList()
    {
        ReqTransRateOrderList                lo_objReqTransRateOrderList = null;
        ServiceResult<ResTransRateOrderList> lo_objResTransRateOrderList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqTransRateOrderList = new ReqTransRateOrderList
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNo    = strOrderNo.ToInt64(),
                AdminID    = objSes.AdminID
            };
                
            lo_objResTransRateOrderList = objOrderDasServices.GetTransRateOrderList(lo_objReqTransRateOrderList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 조회
    /// </summary>
    protected void GetTransRateOrderApplyList()
    {
        ReqTransRateOrderApplyList                lo_objReqTransRateOrderApplyList = null;
        ServiceResult<ResTransRateOrderApplyList> lo_objResTransRateOrderApplyList = null;
        string                                    lo_strFromAddr1                  = string.Empty;
        string                                    lo_strFromAddr2                  = string.Empty;
        string                                    lo_strFromAddr3                  = string.Empty;
        string                                    lo_strToAddr1                    = string.Empty;
        string                                    lo_strToAddr2                    = string.Empty;
        string                                    lo_strToAddr3                    = string.Empty;
        string                                    lo_strGoodsRunType               = "1";          //운행구분 (1:편도, 2:왕복, 3:기타)
        string                                    lo_strLayoverFlag                = "N";          //경유여부
        string                                    lo_strSamePlaceCount             = "0";
        string                                    lo_strNonSamePlaceCount          = "0";

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderLocationCode) )
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlaceFullAddr))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlaceFullAddr))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarTonCode) || string.IsNullOrWhiteSpace(strCarTypeCode))
        {
            objResMap.RetCode = 9008;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFTLFlag))
        {
            objResMap.RetCode = 9009;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strFromAddr1 = strPickupPlaceFullAddr.Split(' ')[0];
            lo_strFromAddr2 = strPickupPlaceFullAddr.Split(' ')[1];
            lo_strFromAddr3 = strPickupPlaceFullAddr.Split(' ').Length.Equals(4) ? strPickupPlaceFullAddr.Split(' ')[2] : string.Empty;
            lo_strToAddr1   = strGetPlaceFullAddr.Split(' ')[0];
            lo_strToAddr2   = strGetPlaceFullAddr.Split(' ')[1];
            lo_strToAddr3   = strGetPlaceFullAddr.Split(' ').Length.Equals(4) ? strGetPlaceFullAddr.Split(' ')[2] : string.Empty;

            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr1) ? ("," + lo_strFromAddr1) : string.Empty;
            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr2) ? (","  + lo_strFromAddr1 + " " + lo_strFromAddr2) : string.Empty;
            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr3) ? (","  + lo_strFromAddr1 + " " + lo_strFromAddr2 + " " + lo_strFromAddr3) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr1) ? ("," + lo_strToAddr1) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr2) ? ("," + lo_strToAddr1 + " " + lo_strToAddr2) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr3) ? ("," + lo_strToAddr1 + " " + lo_strToAddr2 + " " + lo_strToAddr3) : string.Empty;

            lo_objReqTransRateOrderApplyList = new ReqTransRateOrderApplyList
            {
                CenterCode        = strCenterCode.ToInt(),
                ClientCode        = strPayClientCode.ToInt64(),
                ConsignorCode     = strConsignorCode.ToInt64(),
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                FTLFlag           = strFTLFlag,
                CarFixedFlag      = strCarFixedFlag,
                FromAddrs         = strPickupPlaceFullAddr,
                ToAddrs           = strGetPlaceFullAddr,
                GoodsRunType      = lo_strGoodsRunType.ToInt(),
                CarTonCode        = strCarTonCode,
                CarTypeCode       = strCarTypeCode,
                PickupYMD         = strPickupYMD,
                PickupHM          = strPickupHM,
                GetYMD            = strGetYMD,
                GetHM             = strGetHM,
                Volume            = strVolume.ToInt(),
                CBM               = strCBM.ToDouble(),
                Weight            = strWeight.ToDouble(),
                Length            = strLength.ToInt(),
                LayoverFlag       = lo_strLayoverFlag,
                SamePlaceCount    = lo_strSamePlaceCount.ToInt(),
                NonSamePlaceCount = lo_strNonSamePlaceCount.ToInt(),
                AdminID           = objSes.AdminID
            };

            lo_objResTransRateOrderApplyList = objOrderDasServices.GetTransRateOrderApplyList(lo_objReqTransRateOrderApplyList);
            objResMap.strResponse            = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 비용 목록
    /// </summary>
    protected void GetAmtRequestOrderList()
    {
        ReqOrderAmtRequestOrderList                lo_objReqOrderAmtRequestOrderList = null;
        ServiceResult<ResOrderAmtRequestOrderList> lo_objResOrderAmtRequestOrderList = null;
        int                                        lo_intListType                    = 2;

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestOrderList = new ReqOrderAmtRequestOrderList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                ListType         = lo_intListType,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResOrderAmtRequestOrderList = objOrderDasServices.GetOrderAmtRequestOrderList(lo_objReqOrderAmtRequestOrderList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResOrderAmtRequestOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
        
    /// <summary>
    /// 비용 수정요청 등록
    /// </summary>
    protected void SetAmtRequestIns()
    {
        OrderAmtRequestModel                lo_objOrderAmtRequestModel  = null;
        ServiceResult<OrderAmtRequestModel> lo_objResOrderAmtRequestIns = null;
            
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strReqKind) || strReqKind.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strPaySeqNo) || strPaySeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strReqReason))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderAmtRequestModel = new OrderAmtRequestModel
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                ReqKind      = strReqKind.ToInt(),
                PaySeqNo     = strPaySeqNo.ToInt64(),
                ReqSupplyAmt = strReqSupplyAmt.ToDouble(),
                ReqTaxAmt    = strReqTaxAmt.ToDouble(),
                ReqReason    = strReqReason,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResOrderAmtRequestIns = objOrderDasServices.SetOrderAmtRequestIns(lo_objOrderAmtRequestModel);
            objResMap.RetCode           = lo_objResOrderAmtRequestIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderAmtRequestIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo", lo_objResOrderAmtRequestIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 비용 수정요청 취소
    /// </summary>
    protected void SetAmtRequestCnl()
    {
        ReqOrderAmtRequestCnl lo_objReqOrderAmtRequestCnl = null;
        ServiceResult<bool>   lo_objResOrderAmtRequestCnl = null;
            
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestCnl = new ReqOrderAmtRequestCnl
            {
                SeqNo        = strSeqNo.ToInt(),
                CnlAdminID   = objSes.AdminID,
                CnlAdminName = objSes.AdminName
            };

            lo_objResOrderAmtRequestCnl = objOrderDasServices.SetOrderAmtRequestCnl(lo_objReqOrderAmtRequestCnl);
            objResMap.RetCode           = lo_objResOrderAmtRequestCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderAmtRequestCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCostInsHandler", "Exception",
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