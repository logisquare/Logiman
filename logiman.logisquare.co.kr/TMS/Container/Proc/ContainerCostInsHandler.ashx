<%@ WebHandler Language="C#" Class="ContainerCostInsHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : ContainerCostInsHandler.ashx
/// Description     : 컨테이너오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-07-20
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ContainerCostInsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Container/ContainerCostIns"; //필수

    // 메소드 리스트
    private const string MethodContainerList      = "ContainerList";      //오더 목록
    private const string MethodContainerPayList   = "ContainerPayList";   //비용 목록
    private const string MethodContainerPayIns    = "ContainerPayInsert"; //비용 등록
    private const string MethodContainerPayUpd    = "ContainerPayUpdate"; //비용 수정
    private const string MethodContainerPayDel    = "ContainerPayDelete"; //비용 삭제
    private const string MethodContainerCodeList  = "ContainerCodeList";  //회원사별 코드 조회
    private const string MethodClientList         = "ClientList";         //고객사(발주/청구처) 조회
    private const string MethodCarDispatchRefList = "CarDispatchRefList"; //배차차량 조회
    private const string MethodCarCompanyList     = "CarCompanyList";     //차량 업체 조회
    private const string MethodCarList            = "CarList";            //차량 조회
    private const string MethodDriverList         = "DriverList";         //기사 조회(휴대폰, 기사명)
    private const string MethodClientNote         = "ClientNote";         //청구처 특이사항
    private const string MethodClientSaleLimit    = "ClientSaleLimit";    //매출 한도 정보 조회

    ContainerDasServices       objContainerDasServices       = new ContainerDasServices();
    ClientDasServices          objClientDasServices          = new ClientDasServices();
    CarDispatchDasServices     objCarDispatchDasServices     = new CarDispatchDasServices();
    ClientSaleLimitDasServices objClientSaleLimitDasServices = new ClientSaleLimitDasServices();
    private HttpContext        objHttpContext                = null;

    private string strCallType                = string.Empty;
    private int    intPageSize                = 0;
    private int    intPageNo                  = 0;
    private string strCenterCode              = string.Empty;
    private string strDateFrom                = string.Empty;
    private string strDateTo                  = string.Empty;
    private string strOrderLocationCodes      = string.Empty;
    private string strOrderItemCodes          = string.Empty;
    private string strSearchClientType        = string.Empty;
    private string strSearchClientText        = string.Empty;
    private string strSearchChargeType        = string.Empty;
    private string strSearchChargeText        = string.Empty;
    private string strGoodsItemCode           = string.Empty;
    private string strSearchType              = string.Empty;
    private string strSearchText              = string.Empty;
    private string strAcceptAdminName         = string.Empty;
    private string strOrderNo                 = string.Empty;
    private string strMyChargeFlag            = string.Empty;
    private string strMyOrderFlag             = string.Empty;
    private string strCnlFlag                 = string.Empty;
    private string strOrderClientName         = string.Empty;
    private string strOrderClientChargeName   = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strPayClientChargeName     = string.Empty;
    private string strPayClientChargeLocation = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strPickupPlace             = string.Empty;
    private string strCntrNo                  = string.Empty;
    private string strBLNo                    = string.Empty;
    private string strShippingCompany         = string.Empty;
    private string strClientName              = string.Empty;
    private string strClientCode              = string.Empty;
    private string strChargeOrderFlag         = string.Empty;
    private string strChargePayFlag           = string.Empty;
    private string strClientFlag              = string.Empty;
    private string strChargeFlag              = string.Empty;
    private string strComName                 = string.Empty;
    private string strCarNo                   = string.Empty;
    private string strDriverName              = string.Empty;
    private string strDriverCell              = string.Empty;
    private string strSupplyAmt               = string.Empty;
    private string strTaxAmt                  = string.Empty;
    private string strSeqNo                   = string.Empty;
    private string strGoodsSeqNo              = string.Empty;
    private string strDispatchSeqNo           = string.Empty;
    private string strPayType                 = string.Empty;
    private string strTaxKind                 = string.Empty;
    private string strItemCode                = string.Empty;
    private string strRefSeqNo                = string.Empty;
    private string strCarDivType              = string.Empty;
    private string strComCode                 = string.Empty;
    private string strCarSeqNo                = string.Empty;
    private string strDriverSeqNo             = string.Empty;
    private string strPickupYMD               = string.Empty;
    private string strPayClientCode           = string.Empty;
    private string strSortType                = string.Empty;
    private string strInsureExceptKind        = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodContainerList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContainerPayList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContainerPayIns,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerPayUpd,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerPayDel,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerCodeList,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchRefList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarCompanyList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDriverList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientNote,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,    MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ContainerCostInsHandler");
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
            strCenterCode              = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo                 = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strDateFrom                = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                  = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes          = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType        = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText        = SiteGlobal.GetRequestForm("SearchClientText");
            strSearchChargeType        = SiteGlobal.GetRequestForm("SearchChargeType");
            strSearchChargeText        = SiteGlobal.GetRequestForm("SearchChargeText");
            strGoodsItemCode           = SiteGlobal.GetRequestForm("GoodsItemCode");
            strSearchType              = SiteGlobal.GetRequestForm("SearchType");
            strSearchText              = SiteGlobal.GetRequestForm("SearchText");
            strMyChargeFlag            = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag             = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                 = SiteGlobal.GetRequestForm("CnlFlag");
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName   = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName     = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargeLocation = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupPlace             = SiteGlobal.GetRequestForm("PickupPlace");
            strGoodsSeqNo              = SiteGlobal.GetRequestForm("GoodsSeqNo");
            strGoodsItemCode           = SiteGlobal.GetRequestForm("GoodsItemCode");
            strCntrNo                  = SiteGlobal.GetRequestForm("CntrNo");
            strBLNo                    = SiteGlobal.GetRequestForm("BLNo");
            strShippingCompany         = SiteGlobal.GetRequestForm("ShippingCompany");
            strClientName              = SiteGlobal.GetRequestForm("ClientName"); //검색용
            strClientCode              = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strChargeOrderFlag         = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag           = SiteGlobal.GetRequestForm("ChargePayFlag");
            strClientFlag              = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag              = SiteGlobal.GetRequestForm("ChargeFlag");
            strComName                 = SiteGlobal.GetRequestForm("ComName");
            strCarNo                   = SiteGlobal.GetRequestForm("CarNo");
            strDriverName              = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell              = SiteGlobal.GetRequestForm("DriverCell");
            strSupplyAmt               = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),     "0");
            strTaxAmt                  = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),        "0");
            strSeqNo                   = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),         "0");
            strGoodsSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPayType                 = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind                 = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode                = SiteGlobal.GetRequestForm("ItemCode");
            strRefSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),    "0");
            strCarDivType              = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"),  "0");
            strComCode                 = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),     "0");
            strCarSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("CarSeqNo"),    "0");
            strDriverSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
            strPickupYMD               = SiteGlobal.GetRequestForm("PickupYMD");
            strPayClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"),    "0");
            strSortType                = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"),         "1");
            strInsureExceptKind        = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "1");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
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
                case MethodContainerList:
                    GetContainerList();
                    break;
                case MethodContainerPayList:
                    GetContainerPayList();
                    break;
                case MethodContainerPayIns:
                    SetContainerPayIns();
                    break;
                case MethodContainerPayUpd:
                    SetContainerPayUpd();
                    break;
                case MethodContainerPayDel:
                    SetContainerPayDel();
                    break;
                case MethodContainerCodeList:
                    GetContainerCodeList();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodCarDispatchRefList:
                    GetCarDispatchRefList();
                    break;
                case MethodCarCompanyList:
                    GetCarCompanyList();
                    break;
                case MethodCarList:
                    GetCarList();
                    break;
                case MethodDriverList:
                    GetDriverList();
                    break;
                case MethodClientNote:
                    GetClientNote();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
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

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 컨테이너 오더 현황 목록
    /// </summary>
    protected void GetContainerList()
    {
        ReqContainerList                lo_objReqContainerList = null;
        ServiceResult<ResContainerList> lo_objResContainerList = null;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;
        strComName         = string.Empty;
        strCarNo           = string.Empty;
        strPickupPlace     = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchClientType) && !string.IsNullOrWhiteSpace(strSearchClientText))
        {
            switch (strSearchClientType)
            {
                case "1":
                    strOrderClientName = strSearchClientText;
                    break;
                case "2":
                    strPayClientName = strSearchClientText;
                    break;
                case "3":
                    strConsignorName = strSearchClientText;
                    break;
                case "4":
                    strComName = strSearchClientText;
                    break;
                case "5":
                    strCarNo = strSearchClientText;
                    break;
                case "6":
                    strPickupPlace = strSearchClientText;
                    break;
            }
        }
        
        strOrderClientChargeName   = string.Empty;
        strPayClientChargeName     = string.Empty;
        strPayClientChargeLocation = string.Empty;
        strAcceptAdminName         = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchChargeType) && !string.IsNullOrWhiteSpace(strSearchChargeText))
        {
            switch (strSearchChargeType)
            {
                case "1":
                    strOrderClientChargeName = strSearchChargeText;
                    break;
                case "2":
                    strPayClientChargeName = strSearchChargeText;
                    break;
                case "3":
                    strPayClientChargeLocation = strSearchChargeText;
                    break;
                case "4":
                    strAcceptAdminName = strSearchChargeText;
                    break;
            }
        }
        
        strShippingCompany = string.Empty;
        strCntrNo          = string.Empty;
        strBLNo            = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strShippingCompany = strSearchText;
                    break;
                case "2":
                    strCntrNo = strSearchText;
                    break;
                case "3":
                    strBLNo = strSearchText;
                    break;
            }
        }

        try
        {
            lo_objReqContainerList = new ReqContainerList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                PickupPlace             = strPickupPlace,
                AcceptAdminName         = strAcceptAdminName,
                GoodsItemCode           = strGoodsItemCode,
                ShippingCompany         = strShippingCompany,
                CntrNo                  = strCntrNo,
                BLNo                    = strBLNo,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResContainerList = objContainerDasServices.GetContainerList(lo_objReqContainerList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResContainerList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 목록
    /// </summary>
    protected void GetContainerPayList()
    {
        ServiceResult<ResContainerPayList> lo_objResContainerPayList = null;

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResContainerPayList = objContainerDasServices.GetContainerPayList(0, strOrderNo.ToInt64(), objSes.AccessCenterCode);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResContainerPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 등록
    /// </summary>
    protected void SetContainerPayIns()
    {
        ContainerPayModel                lo_objContainerPayModel  = null;
        ServiceResult<ContainerPayModel> lo_objResContainerPayIns = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        strTaxKind    = Utils.IsNull(strTaxKind,    "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        
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
        
        if (!string.IsNullOrWhiteSpace(strSeqNo) && !strSeqNo.Equals("0"))
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

        if (strPayType.Equals("2")) //매입
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strCarDivType) || strCarDivType.Equals("0")|| string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0")|| string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0")|| string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0")) && (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0")))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else if (strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        
        try
        {
            lo_objContainerPayModel = new ContainerPayModel
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                GoodsSeqNo       = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo    = strDispatchSeqNo.ToInt64(),
                PayType          = strPayType.ToInt(),
                TaxKind          = strTaxKind.ToInt(),
                ItemCode         = strItemCode,
                ClientCode       = strClientCode.ToInt64(),
                ClientName       = strClientName,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                CarDivType       = strCarDivType.ToInt(),
                ComCode          = strComCode.ToInt64(),
                CarSeqNo         = strCarSeqNo.ToInt64(),
                DriverSeqNo      = strDriverSeqNo.ToInt64(),
                SupplyAmt        = strSupplyAmt.ToDouble(),
                TaxAmt           = strTaxAmt.ToDouble(),
                InsureExceptKind = strInsureExceptKind.ToInt(),
                RegAdminID       = objSes.AdminID,
                RegAdminName     = objSes.AdminName
            };

            lo_objResContainerPayIns = objContainerDasServices.SetContainerPayIns(lo_objContainerPayModel);
            objResMap.RetCode  = lo_objResContainerPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo",    lo_objResContainerPayIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 수정
    /// </summary>
    protected void SetContainerPayUpd()
    {
        ContainerPayModel   lo_objContainerPayModel  = null;
        ServiceResult<bool> lo_objResContainerPayUpd = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        strTaxKind    = Utils.IsNull(strTaxKind,    "0");
        
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
        
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
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

        if (strPayType.Equals("2")) //매입
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strCarDivType) || strCarDivType.Equals("0")|| string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0")|| string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0")|| string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0")) && (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0")))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else if (strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        
        try
        {
            lo_objContainerPayModel = new ContainerPayModel
            {
                SeqNo            = strSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                GoodsSeqNo       = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo    = strDispatchSeqNo.ToInt64(),
                PayType          = strPayType.ToInt(),
                TaxKind          = strTaxKind.ToInt(),
                ItemCode         = strItemCode,
                ClientCode       = strClientCode.ToInt64(),
                ClientName       = strClientName,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                CarDivType       = strCarDivType.ToInt(),
                ComCode          = strComCode.ToInt64(),
                CarSeqNo         = strCarSeqNo.ToInt64(),
                DriverSeqNo      = strDriverSeqNo.ToInt64(),
                SupplyAmt        = strSupplyAmt.ToDouble(),
                TaxAmt           = strTaxAmt.ToDouble(),
                InsureExceptKind = strInsureExceptKind.ToInt(),
                UpdAdminID       = objSes.AdminID,
                UpdAdminName     = objSes.AdminName
            };

            lo_objResContainerPayUpd = objContainerDasServices.SetContainerPayUpd(lo_objContainerPayModel);
            objResMap.RetCode  = lo_objResContainerPayUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 삭제
    /// </summary>
    protected void SetContainerPayDel()
    {
        ServiceResult<bool> lo_objResContainerPayDel = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        
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
        
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
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
        
        try
        {
            lo_objResContainerPayDel = objContainerDasServices.SetContainerPayDel(strSeqNo.ToInt64(), strCenterCode.ToInt(), strOrderNo.ToInt64(), strPayType.ToInt(), objSes.AdminID, objSes.AdminName);
            objResMap.RetCode        = lo_objResContainerPayDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetContainerCodeList()
    {
        string    lo_strLocationGroupName = string.Empty;
        DataTable lo_objLocationCodeTable = null;
        string    lo_strPayItemGroupName  = string.Empty;
        DataTable lo_objPayItemCodeTable  = null;

        if(string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objLocationCodeTable = Utils.GetItemList(objHttpContext, "OL", strCenterCode, objSes.AdminID, out lo_strLocationGroupName);
            if (lo_objLocationCodeTable != null)
            {
                 objResMap.Add("LocationCode", lo_objLocationCodeTable.Rows.OfType<DataRow>().Select(dr => new { 
                        ItemFullCode = dr.Field<string>("ItemFullCode"),
                        ItemName   = dr.Field<string>("ItemName")
                    }).ToList());
            }
             
            lo_objPayItemCodeTable = Utils.GetItemList(objHttpContext, "OP", strCenterCode, objSes.AdminID, out lo_strPayItemGroupName);
            if (lo_objPayItemCodeTable != null)
            {
                objResMap.Add("PayItemCode", lo_objPayItemCodeTable.Rows.OfType<DataRow>().Select(dr => new
                {
                    ItemFullCode = dr.Field<string>("ItemFullCode"),
                    ItemName     = dr.Field<string>("ItemName")
                }).ToList());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사(발주처, 청구처, 업체명) 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        try
        {
            lo_objReqClientSearchList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                UseFlag          = "Y",
                ChargeOrderFlag  = strChargeOrderFlag,
                ChargePayFlag    = strChargePayFlag,
                ChargeUseFlag    = "Y",
                ClientFlag       = strClientFlag,
                ChargeFlag       = strChargeFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientSearchList = objClientDasServices.GetClientSearchList(lo_objReqClientSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 배차 차량검색
    /// </summary>
    protected void GetCarDispatchRefList()
    {
        ReqCarDispatchRefSearchList                lo_objReqCarDispatchRefSearchList = null;
        ServiceResult<ResCarDispatchRefSearchList> lo_objResCarDispatchRefSearchList = null;
            
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

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 업체 검색
    /// </summary>
    protected void GetCarCompanyList()
    {
        ReqCarCompanySearchList                lo_objReqCarCompanySearchList = null;
        ServiceResult<ResCarCompanySearchList> lo_objResCarCompanySearchList = null;

        if (string.IsNullOrWhiteSpace(strComName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarCompanySearchList = new ReqCarCompanySearchList
            {
                ComName  = strComName,
                UseFlag  = "Y",
                PageSize = intPageSize,
                PageNo   = intPageNo
            };

            lo_objResCarCompanySearchList = objCarDispatchDasServices.GetCarCompanySearchList(lo_objReqCarCompanySearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarCompanySearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량정보 검색
    /// </summary>
    protected void GetCarList()
    {
        ReqCarSearchList                lo_objReqCarSearchList = null;
        ServiceResult<ResCarSearchList> lo_objResCarSearchList = null;

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarSearchList = new ReqCarSearchList
            {
                CarNo  = strCarNo,
                UseFlag  = "Y",
                PageSize = intPageSize,
                PageNo   = intPageNo
            };

            lo_objResCarSearchList = objCarDispatchDasServices.GetCarSearchList(lo_objReqCarSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 기사 검색
    /// </summary>
    protected void GetDriverList()
    {
        ReqCarDriverSearchList                lo_objReqCarDriverSearchList = null;
        ServiceResult<ResCarDriverSearchList> lo_objResCarDriverSearchList = null;

        if (string.IsNullOrWhiteSpace(strDriverName) && string.IsNullOrWhiteSpace(strDriverCell))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDriverSearchList = new ReqCarDriverSearchList
            {
                DriverName = strDriverName,
                DriverCell = strDriverCell,
                UseFlag    = "Y",
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCarDriverSearchList = objCarDispatchDasServices.GetCarDriverSearchList(lo_objReqCarDriverSearchList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResCarDriverSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 업체 정보 & 비고
    /// </summary>
    protected void GetClientNote()
    {   
        ReqClientList                   lo_objReqClientList    = null;
        ServiceResult<ResClientList>    lo_objResClientList    = null;

        if(string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

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
            objResMap.Add("ClientNote", lo_objResClientList.data.list[0].ClientNote2);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 거래처 매출 한도 및 원가율 조회
    /// </summary>
    protected void GetClientSaleLimit()
    {
        ReqClientSaleLimit                lo_objReqClientSaleLimit = null;
        ServiceResult<ResClientSaleLimit> lo_objResClientSaleLimit = null;

        strPickupYMD = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        
        if (string.IsNullOrWhiteSpace(strPickupYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientSaleLimit = new ReqClientSaleLimit
            {
                YMD        = strPickupYMD,
                CenterCode = strCenterCode.ToInt(),
                ClientCode = strPayClientCode.ToInt64(),
                OrderNo    = strOrderNo.ToInt64()
            };

            lo_objResClientSaleLimit = objClientSaleLimitDasServices.GetClientSaleLimit(lo_objReqClientSaleLimit);
            objResMap.RetCode        = lo_objResClientSaleLimit.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientSaleLimit.result.ErrorMsg;
                return;
            }

            objResMap.Add("ClientBusinessStatus", lo_objResClientSaleLimit.data.ClientBusinessStatus);
            objResMap.Add("LimitCheckFlag",       lo_objResClientSaleLimit.data.LimitCheckFlag);
            objResMap.Add("LimitAvailFlag",       lo_objResClientSaleLimit.data.LimitAvailFlag);
            objResMap.Add("SaleLimitAmt",         lo_objResClientSaleLimit.data.SaleLimitAmt);
            objResMap.Add("LimitAvailAmt",        lo_objResClientSaleLimit.data.LimitAvailAmt);
            objResMap.Add("RevenueLimitPer",      lo_objResClientSaleLimit.data.RevenueLimitPer);
            objResMap.Add("TotalSaleAmt",         lo_objResClientSaleLimit.data.TotalSaleAmt);
            objResMap.Add("TotalPurchaseAmt",     lo_objResClientSaleLimit.data.TotalPurchaseAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerCostInsHandler", "Exception",
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