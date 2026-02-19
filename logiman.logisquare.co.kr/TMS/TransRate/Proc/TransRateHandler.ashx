<%@ WebHandler Language="C#" Class="TransRateHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : TransRateHandler.ashx
/// Description     : 요율표 관련
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class TransRateHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/TransRate/TransRateList?RateRegKind=1"; //필수

    // 메소드 리스트
    private const string MethodTransRateList                 = "TransRateList";
    private const string MethodTransRateGet                  = "TransRateGet";
    private const string MethodTransRateApplyClientList      = "TransRateApplyClientList";
    private const string MethodAddrList                      = "AddrList";
    private const string MethodTransRateDtlInsert            = "TransRateDtlInsert";
    private const string MethodTransRateDtlUpdate            = "TransRateDtlUpdate";
    private const string MethodCarTonExcel                   = "CarTonExcel";
    private const string MethodCarTruckExcel                 = "CarTruckExcel";
    private const string MethodAddrListExcel                 = "AddrListExcel";
    private const string MethodItemCodeList                  = "ItemCodeList";
    private const string MethodTransRateDtlHistList          = "TransRateDtlHistList";
    private const string MethodTransRateDtlList              = "TransRateDtlList";
    private const string MethodTransRateDtlListExcel         = "TransRateDtlListExcel";
    private const string MethodTransRateUpd                  = "TransRateUpd";
    private const string MethodTransRateApplyDel             = "TransRateApplyDel";
    private const string MethodTransRateApplyList            = "TransRateApplyList";
    private const string MethodClientTransRateGroupExcelList = "ClientTransRateGroupExcelList";

    TransRateDasServices      objClientTransRateDasServices   = new TransRateDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strApplySeqNo  = string.Empty;
    private string strTransSeqNo  = string.Empty;
    private string strCenterCode  = string.Empty;
    private string strRateRegKind = string.Empty;
    private string strRateType    = string.Empty;

    private string strFTLFlag     = string.Empty;
    private string strFTLFlagList = string.Empty;
    private string strDelFlag     = string.Empty;
    private string strAddrText    = string.Empty;

    private string strTransRateName = string.Empty;
    private string strGoodsRunType  = string.Empty;
    private string strFromSido      = string.Empty;
    private string strFromGugun     = string.Empty;
    private string strFromDong      = string.Empty;

    private string strFromAreaCode = string.Empty;
    private string strToSido       = string.Empty;
    private string strToGugun      = string.Empty;
    private string strToDong       = string.Empty;
    private string strToAreaCode   = string.Empty;

    private string strCarTonCode    = string.Empty;
    private string strCarTypeCode   = string.Empty;
    private string strTypeValueFrom = string.Empty;
    private string strTypeValueTo   = string.Empty;
    private string strSaleUnitAmt   = string.Empty;

    private string strPurchaseUnitAmt         = string.Empty;
    private string strFixedPurchaseUnitAmt    = string.Empty;
    private string strExtSaleUnitAmt          = string.Empty;
    private string strExtPurchaseUnitAmt      = string.Empty;
    private string strExtFixedPurchaseUnitAmt = string.Empty;

    private string strDtlSeqNo          = string.Empty;
    private string strCodeType          = string.Empty;
    private string strFromFullAddr      = string.Empty;
    private string strToFullAddr        = string.Empty;
    private string strUpdType           = string.Empty;
    private string strClientCode        = string.Empty;
    private string strConsignorCode     = string.Empty;
    private string strClientName        = string.Empty;
    private string strConsignorName     = string.Empty;
    private string strOrderItemCode     = string.Empty;
    private string strOrderLocationCode = string.Empty;


    private HttpContext           objHttpContext = null;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodTransRateList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateGet,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyClientList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAddrList,                       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateDtlInsert,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateDtlUpdate,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCarTonExcel,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarTruckExcel,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAddrListExcel,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodItemCodeList,                   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateDtlList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateDtlListExcel,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateDtlHistList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateUpd,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientTransRateGroupExcelList,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyDel,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateApplyList,  MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("TransRateHandler");
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

            strApplySeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"), "0");
            strTransSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("TransSeqNo"), "0");
            strCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strRateRegKind = Utils.IsNull(SiteGlobal.GetRequestForm("RateRegKind"), "0");
            strRateType    = Utils.IsNull(SiteGlobal.GetRequestForm("RateType"), "0");

            strFTLFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlag"), "N");
            strFTLFlagList   = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlagList"), "");
            strDelFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("DelFlag"), "");
            strAddrText      = Utils.IsNull(SiteGlobal.GetRequestForm("AddrText"), "");
            strTransRateName = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateName"), "");
            strGoodsRunType  = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"), "1");

            strFromSido      = Utils.IsNull(SiteGlobal.GetRequestForm("FromSido"), "");
            strFromGugun     = Utils.IsNull(SiteGlobal.GetRequestForm("FromGugun"), "");
            strFromDong      = Utils.IsNull(SiteGlobal.GetRequestForm("FromDong"), "");
            strFromAreaCode = Utils.IsNull(SiteGlobal.GetRequestForm("FromAreaCode"), "");
            strToSido       = Utils.IsNull(SiteGlobal.GetRequestForm("ToSido"), "");

            strToGugun      = Utils.IsNull(SiteGlobal.GetRequestForm("ToGugun"), "");
            strToDong       = Utils.IsNull(SiteGlobal.GetRequestForm("ToDong"), "");
            strToAreaCode   = Utils.IsNull(SiteGlobal.GetRequestForm("ToAreaCode"), "");
            strCarTonCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CarTonCode"), "");
            strCarTypeCode   = Utils.IsNull(SiteGlobal.GetRequestForm("CarTypeCode"), "");

            strTypeValueFrom = Utils.IsNull(SiteGlobal.GetRequestForm("TypeValueFrom"), "0");
            strTypeValueTo   = Utils.IsNull(SiteGlobal.GetRequestForm("TypeValueTo"), "0");
            strSaleUnitAmt   = Utils.IsNull(SiteGlobal.GetRequestForm("SaleUnitAmt"), "0").Replace("%", "");
            strPurchaseUnitAmt         = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseUnitAmt"), "0").Replace("%", "");
            strFixedPurchaseUnitAmt    = Utils.IsNull(SiteGlobal.GetRequestForm("FixedPurchaseUnitAmt"), "0").Replace("%", "");

            strExtSaleUnitAmt          = Utils.IsNull(SiteGlobal.GetRequestForm("ExtSaleUnitAmt"), "0");
            strExtPurchaseUnitAmt      = Utils.IsNull(SiteGlobal.GetRequestForm("ExtPurchaseUnitAmt"), "0");
            strExtFixedPurchaseUnitAmt = Utils.IsNull(SiteGlobal.GetRequestForm("ExtFixedPurchaseUnitAmt"), "0");

            strDtlSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("DtlSeqNo"), "0");
            strCodeType          = Utils.IsNull(SiteGlobal.GetRequestForm("CodeType"), "");
            strFromFullAddr      = Utils.IsNull(SiteGlobal.GetRequestForm("FromFullAddr"), "");
            strToFullAddr        = Utils.IsNull(SiteGlobal.GetRequestForm("ToFullAddr"), "");
            strUpdType           = Utils.IsNull(SiteGlobal.GetRequestForm("UpdType"), "0");
            strClientCode        = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strConsignorCode     = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strClientName        = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            strConsignorName     = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
            strOrderItemCode     = Utils.IsNull(SiteGlobal.GetRequestForm("OrderItemCode"), "");
            strOrderLocationCode = Utils.IsNull(SiteGlobal.GetRequestForm("OrderLocationCode"), "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
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
                case MethodTransRateList:
                    GetTransRateList();
                    break;
                case MethodTransRateGet:
                    GetTransRateGet();
                    break;
                case MethodTransRateApplyClientList:
                    GetTransRateApplyClientList();
                    break;
                case MethodAddrList:
                    GetAddrList();
                    break;
                case MethodCarTonExcel:
                    GetCarTonExcel();
                    break;
                case MethodCarTruckExcel:
                    GetCarTruckExcel();
                    break;
                case MethodAddrListExcel:
                    GetAddrListExcel();
                    break;
                case MethodTransRateDtlInsert:
                    SetTransRateDtlInsert();
                    break;
                case MethodItemCodeList:
                    GetItemList();
                    break;
                case MethodTransRateDtlHistList:
                    GetTransRateDtlHistList();
                    break;
                case MethodTransRateDtlList:
                    GetTransRateDtlList();
                    break;
                case MethodTransRateDtlListExcel:
                    GetTransRateDtlListExcel();
                    break;
                case MethodTransRateDtlUpdate:
                    SetTransRateDtlUpd();
                    break;
                case MethodTransRateUpd:
                    SetTransRateUpd();
                    break;
                case MethodTransRateApplyDel:
                    SetTransRateApplyDel();
                    break;
                case MethodTransRateApplyList:
                    GetTransRateApplyList();
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

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 요율표 그룹 리스트
    /// </summary>
    protected void GetTransRateList()
    {
        ReqTransRateList                lo_objReqTransRateList = null;
        ServiceResult<ResTransRateList> lo_objResTransRateList = null;

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                RateRegKind      = strRateRegKind.ToInt(),
                RateType         = strRateType.ToInt(),
                TransRateName    = strTransRateName,
                FTLFlag          = strFTLFlagList,
                DelFlag          = strDelFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateList = objClientTransRateDasServices.GetTransRateList(lo_objReqTransRateList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResTransRateList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 적용 고객사 리스트
    /// </summary>
    protected void GetTransRateApplyClientList()
    {
        ReqTransRateList                           lo_objReqTransRateList = null;
        ServiceResult<ResTransRateApplyClientList> lo_objResTransRateList = null;

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                ApplySeqNo       = strApplySeqNo.ToInt64(),
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                RateRegKind      = strRateRegKind.ToInt(),
                FTLFlag          = strFTLFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateList = objClientTransRateDasServices.GetTransRateApplyClientList(lo_objReqTransRateList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResTransRateList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    //요율표 상세 내역 등록
    protected void SetTransRateDtlInsert()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        Int64 lo_intTransSeqNo = 0;
        Int64 lo_intDtlSeqNo   = 0;

        switch (strRateType.ToInt())
        {
            case 1 :
                strTypeValueFrom = "0";
                strTypeValueTo = "0";
                break;
            case 2 :
                strGoodsRunType = "1";
                strCarTypeCode     = "";
                break;
            case 7 :
                strGoodsRunType = "1";
                break;
            case 8 :
                strGoodsRunType = "1";
                break;
            default :
                strGoodsRunType = "1";
                strCarTypeCode  = "";
                strCarTonCode   = "";
                break;
        }

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                TransSeqNo  = strTransSeqNo.ToInt64(),
                CenterCode  = strCenterCode.ToInt(),
                RateRegKind = strRateRegKind.ToInt(),
                RateType    = strRateType.ToInt(),
                FTLFlag     = strFTLFlag,

                TransRateName = strTransRateName,
                GoodsRunType  = strGoodsRunType.ToInt(),
                FromSido      = strFromSido,
                FromGugun     = strFromGugun,
                FromDong      = strFromDong,

                FromAreaCode = strFromAreaCode,
                ToSido       = strToSido,
                ToGugun      = strToGugun,
                ToDong       = strToDong,
                ToAreaCode   = strToAreaCode,

                CarTonCode    = strCarTonCode,
                CarTypeCode   = strCarTypeCode,
                TypeValueFrom = strTypeValueFrom.ToDouble(),
                TypeValueTo   = strTypeValueTo.ToDouble(),
                SaleUnitAmt   = strSaleUnitAmt.ToDouble(),

                PurchaseUnitAmt         = strPurchaseUnitAmt.ToDouble(),
                FixedPurchaseUnitAmt    = strFixedPurchaseUnitAmt.ToDouble(),
                ExtSaleUnitAmt          = strExtSaleUnitAmt.ToDouble(),
                ExtPurchaseUnitAmt      = strExtPurchaseUnitAmt.ToDouble(),
                ExtFixedPurchaseUnitAmt = strExtFixedPurchaseUnitAmt.ToDouble(),

                RegAdminID = objSes.AdminID
            };

            lo_objResTransRateModel = objClientTransRateDasServices.SetTransRateDtlIns(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
            else
            {
                lo_intTransSeqNo = lo_objResTransRateModel.data.OutTransSeqNo;
                lo_intDtlSeqNo   = lo_objResTransRateModel.data.DtlSeqNo;
                
                objResMap.Add("TransSeqNo", lo_intTransSeqNo);
                objResMap.Add("DtlSeqNo", lo_intDtlSeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 상세 히스토리 리스트
    /// </summary>
    protected void GetTransRateDtlHistList()
    {
        ReqTransRateList                   lo_objReqTransRateList    = null;
        ServiceResult<ResTransRateDtlList> lo_objResTransRateDtlList = null;

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                DtlSeqNo         = strDtlSeqNo.ToInt64(),
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateDtlList = objClientTransRateDasServices.GetTransRateDtlHistList(lo_objReqTransRateList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResTransRateDtlList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 상세 히스토리 리스트
    /// </summary>
    protected void GetTransRateDtlList()
    {
        ReqTransRateList                   lo_objReqTransRateList    = null;
        ServiceResult<ResTransRateDtlList> lo_objResTransRateDtlList = null;

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                RateRegKind      = strRateRegKind.ToInt(),
                RateType         = strRateType.ToInt(),
                GoodsRunType     = strGoodsRunType.ToInt(),
                TransRateName    = strTransRateName,
                FromFullAddr     = strFromFullAddr,
                ToFullAddr       = strToFullAddr,
                DelFlag          = strDelFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateDtlList = objClientTransRateDasServices.GetTransRateDtlList(lo_objReqTransRateList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResTransRateDtlList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 상세 히스토리 리스트
    /// </summary>
    protected void GetTransRateDtlListExcel()
    {
        string lo_strTypeValue  = string.Empty;

        ReqTransRateList                   lo_objReqTransRateList    = null;
        ServiceResult<ResTransRateDtlList> lo_objResTransRateDtlList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;
        
        if (strRateType.ToInt().Equals(2))
        {
            lo_strTypeValue = "시간(분)";
        }else if (strRateType.ToInt().Equals(3))
        {
            lo_strTypeValue = "수량(ea)";
        }else if (strRateType.ToInt().Equals(4))
        {
            lo_strTypeValue = "부피(cbm)";
        }else if (strRateType.ToInt().Equals(5))
        {
            lo_strTypeValue = "중량(kg)";
        }else if (strRateType.ToInt().Equals(6))
        {
            lo_strTypeValue = "길이(cm)";
        }else if (strRateType.ToInt().Equals(8))
        {
            lo_strTypeValue = "유가금액(원)";
        }

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                RateRegKind      = strRateRegKind.ToInt(),
                RateType         = strRateType.ToInt(),
                GoodsRunType     = strGoodsRunType.ToInt(),
                TransRateName    = strTransRateName,
                FromFullAddr     = strFromFullAddr,
                ToFullAddr       = strToFullAddr,
                DelFlag          = strDelFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateDtlList = objClientTransRateDasServices.GetTransRateDtlList(lo_objReqTransRateList);
            lo_dtData                 = new DataTable();
            lo_strFileName            = lo_objResTransRateDtlList.data.list[0].TransRateName;
            if (strRateRegKind.ToInt() <= 3)
            {
                lo_dtData.Columns.Add(new DataColumn("(상)관역시,도",   typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("(상)시,군,구",    typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("(상)읍,면,동",     typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("(하)관역시,도",   typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("(하)시,군,구",    typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("(하)읍,면,동",     typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("운행구분", typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("차량톤급", typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("차량종류", typeof(string)));
                if (!strRateType.ToInt().Equals(1)  || !strRateType.ToInt().Equals(7) || !strRateType.ToInt().Equals(8))
                {
                    lo_dtData.Columns.Add(new DataColumn(lo_strTypeValue + "이상", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn(lo_strTypeValue + "미만", typeof(string)));
                }
                lo_dtData.Columns.Add(new DataColumn("매출", typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("매입(고정차)", typeof(string)));
                lo_dtData.Columns.Add(new DataColumn("매입(용차)", typeof(string)));

                foreach (var row in lo_objResTransRateDtlList.data.list)
                {
                    lo_dtData.Rows.Add(row.FromSido, row.FromGugun, row.FromDong, row.ToSido, row.ToGugun
                                      ,row.ToDong, row.GoodsRunTypeM, row.CarTonCodeM, row.CarTypeCodeM, row.TypeValueFrom
                                      ,row.TypeValueTo,row.SaleUnitAmt,row.FixedPurchaseUnitAmt,row.PurchaseUnitAmt);
                }
            }
            else
            {
                if (strRateRegKind.ToInt().Equals(4))
                {
                    lo_dtData.Columns.Add(new DataColumn("차량톤급", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("차량종류", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매출(동일지역/1곳)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매출(타지역/1곳)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-고정차(동일지역/1곳)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-고정차(타지역/1곳)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-용차(동일지역/1곳)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-용차(타지역/1곳)", typeof(string)));
                }
                else
                {
                    lo_dtData.Columns.Add(new DataColumn(lo_strTypeValue + "이상", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn(lo_strTypeValue + "미만", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매출(%)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-고정(%)", typeof(string)));
                    lo_dtData.Columns.Add(new DataColumn("매입-용차(%)", typeof(string)));
                }

                foreach (var row in lo_objResTransRateDtlList.data.list)
                {
                    if (strRateRegKind.ToInt().Equals(4))
                    {
                        lo_dtData.Rows.Add(row.CarTonCodeM, row.CarTypeCodeM, row.SaleUnitAmt,row.ExtSaleUnitAmt,row.FixedPurchaseUnitAmt
                                          ,row.ExtFixedPurchaseUnitAmt, row.PurchaseUnitAmt, row.ExtPurchaseUnitAmt);
                    }
                    else
                    {
                        lo_dtData.Rows.Add(row.TypeValueFrom, row.TypeValueTo, row.SaleUnitAmt,row.FixedPurchaseUnitAmt, row.PurchaseUnitAmt);
                    }
                }
            }



            lo_objExcel = new SpreadSheet {SheetName = lo_strFileName};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);


            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"{lo_objExcel.SheetName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    //요율표 상세 내역 수얼
    protected void SetTransRateDtlUpd()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                CenterCode  = strCenterCode.ToInt(),
                DtlSeqNo    = strDtlSeqNo.ToInt64(),
                TransSeqNo  = strTransSeqNo.ToInt64(),
                RateRegKind = strRateRegKind.ToInt(),
                SaleUnitAmt = strSaleUnitAmt.ToDouble(),

                PurchaseUnitAmt         = strPurchaseUnitAmt.ToDouble(),
                FixedPurchaseUnitAmt    = strFixedPurchaseUnitAmt.ToDouble(),
                ExtSaleUnitAmt          = strExtSaleUnitAmt.ToDouble(),
                ExtPurchaseUnitAmt      = strPurchaseUnitAmt.ToDouble(),
                ExtFixedPurchaseUnitAmt = strExtFixedPurchaseUnitAmt.ToDouble(),

                TypeValueFrom = strTypeValueFrom.ToDouble(),
                TypeValueTo = strTypeValueTo.ToDouble(),
                DelFlag                 = strDelFlag,
                UpdAdminID              = objSes.AdminID
            };

            lo_objResTransRateModel = objClientTransRateDasServices.SetTransRateDtlUpd(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    //요율표 상세 내역 수얼
    protected void SetTransRateUpd()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                TransSeqNo  = strTransSeqNo.ToInt64(),
                CenterCode  = strCenterCode.ToInt(),
                RateRegKind = strRateRegKind.ToInt(),
                DelFlag     = strDelFlag,
                UpdAdminID  = objSes.AdminID
            };

            lo_objResTransRateModel = objClientTransRateDasServices.SetTransRateUpd(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    //적용 고객사 삭제
    protected void SetTransRateApplyDel()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                TransSeqNo  = strTransSeqNo.ToInt64(),
                ApplySeqNo  = strApplySeqNo.ToInt64(),
                CenterCode  = strCenterCode.ToInt(),
                UpdType     = strUpdType.ToInt(),
                RateRegKind = strRateRegKind.ToInt(),
                UpdAdminID  = objSes.AdminID
            };

            lo_objResTransRateModel = objClientTransRateDasServices.SetTransRateApplyDel(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ApplySeqNo", strApplySeqNo.ToInt64());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 요율표 상세 히스토리 리스트
    /// </summary>
    protected void GetTransRateApplyList()
    {
        ReqTransRateApplyList                   lo_objReqTransRateApplyList    = null;
        ServiceResult<ResTransRateApplyList> lo_objResTransRateApplyList = null;

        try
        {
            lo_objReqTransRateApplyList = new ReqTransRateApplyList
            {
                ApplySeqNo       = strApplySeqNo.ToInt64(),
                ClientCode       = strClientCode.ToInt64(),
                ClientName        = strClientName,
                CenterCode       = strCenterCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt64(),

                ConsignorName     = strConsignorName,
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                DelFlag           = strDelFlag,
                AccessCenterCode  = objSes.AccessCenterCode,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResTransRateApplyList = objClientTransRateDasServices.GetTransRateApplyList(lo_objReqTransRateApplyList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResTransRateApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    //적용 고객사 삭제
    protected void GetTransRateGet()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                TransSeqNo    = strTransSeqNo.ToInt64(),
                CenterCode    = strCenterCode.ToInt(),
                RateRegKind   = strRateRegKind.ToInt(),
                RateType      = strRateType.ToInt(),
                FTLFlag       = strFTLFlag,
                TransRateName = strTransRateName
            };

            lo_objResTransRateModel = objClientTransRateDasServices.GetTransRateGet(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }else
            {
                objResMap.Add("TransSeqNo", lo_objResTransRateModel.data.OutTransSeqNo);
                objResMap.Add("Exists", lo_objResTransRateModel.data.Exists);
                objResMap.Add("DelFlag", lo_objResTransRateModel.data.DelFlag);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9501;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }


    protected void GetCarTonExcel()
    {
        DataTable    lo_dtData    = null;
        DataTable    lo_dtGetData = null;
        SpreadSheet  lo_objExcel  = null;
        MemoryStream lo_outputStream;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        string strFileName = string.Empty;

        try
        {
            string lo_strFileName = CommonConstant.M_PAGE_CACHE_ITEM_LIST_JSON;
            if (!File.Exists(lo_strFileName))
            {
                return;
            }

            string lo_strJson = File.ReadAllText(lo_strFileName);
            lo_dtGetData = JsonConvert.DeserializeObject<DataTable>(lo_strJson);
            lo_dtGetData = lo_dtGetData.DefaultView.ToTable(true, "SeqNo", "ItemName", "ItemGroupCode");
            lo_dtGetData = lo_dtGetData.Select("ItemGroupCode = 'CB' ", "SeqNo ASC").CopyToDataTable();

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("차량톤수", typeof(string)));
            foreach (DataRow row in lo_dtGetData.Rows)
            {
                lo_dtData.Rows.Add(row["ItemName"]);
            }
            strFileName = "차량톤수_(" + objSes.AdminName + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ").xlsx";
            lo_objExcel = new SpreadSheet();
            lo_objExcel.SheetName = "차량톤수";

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.Yellow,
                HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9533;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetCarTruckExcel()
    {
        DataTable    lo_dtData    = null;
        DataTable    lo_dtGetData = null;
        SpreadSheet  lo_objExcel  = null;
        MemoryStream lo_outputStream;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        string strFileName = string.Empty;

        try
        {
            string lo_strFileName = CommonConstant.M_PAGE_CACHE_ITEM_LIST_JSON;
            if (!File.Exists(lo_strFileName))
            {
                return;
            }

            string lo_strJson = File.ReadAllText(lo_strFileName);
            lo_dtGetData = JsonConvert.DeserializeObject<DataTable>(lo_strJson);
            lo_dtGetData = lo_dtGetData.DefaultView.ToTable(true, "SeqNo", "ItemName", "ItemGroupCode");
            lo_dtGetData = lo_dtGetData.Select("ItemGroupCode = 'CA' ", "SeqNo ASC").CopyToDataTable();

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("차량종류", typeof(string)));
            foreach (DataRow row in lo_dtGetData.Rows)
            {
                lo_dtData.Rows.Add(row["ItemName"]);
            }
            strFileName = "차량종류_(" + objSes.AdminName + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ").xlsx";
            lo_objExcel = new SpreadSheet();
            lo_objExcel.SheetName = "차량종류";

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.Yellow,
                HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9511;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAddrListExcel()
    {
        DataTable lo_dtData = null;
        DataTable lo_dtGetData = null;
        SpreadSheet lo_objExcel = null;
        MemoryStream lo_outputStream;
        byte[] lo_Content = null;
        int lo_intColumnIndex = 0;

        string strFileName = string.Empty;

        try
        {
            string lo_strFileName = CommonConstant.M_PAGE_CACHE_ADDRLIST_JSON;
            if (!File.Exists(lo_strFileName))
            {
                return;
            }

            string lo_strJson = File.ReadAllText(lo_strFileName);
            lo_dtGetData = JsonConvert.DeserializeObject<DataTable>(lo_strJson);
            lo_dtGetData = lo_dtGetData.DefaultView.ToTable(true, "KKO_FULLADDR", "KKO_SIDO", "GUGUN", "DONG");
            lo_dtGetData = lo_dtGetData.Select("", "KKO_FULLADDR ASC").CopyToDataTable();

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("전체", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시/도", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시/군/구", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("동/읍/면", typeof(string)));
            foreach (DataRow row in lo_dtGetData.Rows)
            {
                lo_dtData.Rows.Add(row["KKO_FULLADDR"], row["KKO_SIDO"], row["GUGUN"], row["DONG"]);
            }
            strFileName = "주소양식_(" + objSes.AdminID + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ").xlsx";
            lo_objExcel = new SpreadSheet();
            lo_objExcel.SheetName = "주소";

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.Yellow,
                HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "");

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9521;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 주소 검색(메모리)
    /// </summary>
    protected void GetAddrList()
    {
        DataTable lo_dtList = null;

        /*if (string.IsNullOrEmpty(strAddrText))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg = "필요한 값이 없습니다.";
            return;
        }*/

        try
        {
            if (null == objHttpContext.Cache[CommonConstant.M_PAGE_CACHE_ADDRLIST])
            {
                objResMap.RetCode = 9999;
                objResMap.ErrMsg = "데이터가 없습니다";
                return;
            }

            lo_dtList = objHttpContext.Cache.Get(CommonConstant.M_PAGE_CACHE_ADDRLIST) as DataTable;
            if (lo_dtList.Select("KKO_FULLADDR LIKE '%" + strAddrText + "%' ").Length <= 0)
            {
                objResMap.RetCode = 9999;
                objResMap.ErrMsg = "데이터가 없습니다";
                return;
            }

            lo_dtList = lo_dtList.Select("KKO_FULLADDR LIKE '%" + strAddrText + "%' ", "KKO_FULLADDR ASC").CopyToDataTable();
            if (lo_dtList.Rows.Count <= 0)
            {
                objResMap.RetCode = 9999;
                objResMap.ErrMsg = "데이터가 없습니다";
                return;
            }

            lo_dtList = lo_dtList.DefaultView.ToTable(true, "KKO_SIDO", "GUGUN", "DONG", "KKO_FULLADDR");
            lo_dtList.Columns.Add("ADDR");
            foreach (DataRow row in lo_dtList.Rows)
            {
                //row["ADDR"] = row["KKO_SIDO"].ToString() + " " + row["GUGUN"].ToString() + (string.IsNullOrWhiteSpace(row["GUGUN"].ToString()) ? "" : (" " + row["DONG"].ToString()));
                row["ADDR"] = row["KKO_FULLADDR"].ToString();
            }

            objResMap.RetCode = 0;
            objResMap.ErrMsg = string.Empty;
            objResMap.strResponse = SiteGlobal.DataTableToRestJson(0, "OK", lo_dtList, lo_dtList.Rows.Count);
            objResMap.strResponse = "[" + objResMap.strResponse + "]";

        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "ClientTransRateHandler",
                "Exception"
                , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9453);
        }
    }

    protected void GetItemList()
    {
        string    lo_strGroupName         = string.Empty;
        DataTable lo_objLocationCodeTable = null;

        try
        {

            lo_objLocationCodeTable = Utils.GetItemList(objHttpContext, strCodeType, objSes.AccessCenterCode, objSes.AdminID, out lo_strGroupName);
            if (lo_objLocationCodeTable != null)
            {
                objResMap.Add("LocationCode", lo_objLocationCodeTable.Rows.OfType<DataRow>().Select(dr => new {
                    ItemFullCode = dr.Field<string>("ItemFullCode"),
                    ItemName     = dr.Field<string>("ItemName")
                }).ToList());
            }

        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                                "ClientTransRateHandler",
                                "Exception"
                              , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9454);
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