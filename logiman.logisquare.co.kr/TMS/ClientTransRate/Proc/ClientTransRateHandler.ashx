<%@ WebHandler Language="C#" Class="ClientTransRateHandler" %>
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
/// FileName        : ClientTransRateHandler.ashx
/// Description     : 요율표 관련
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-22
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ClientTransRateHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClientTransRate/ClientTransRateList"; //필수

    // 메소드 리스트
    private const string MethodClientTransRateGroupList         = "ClientTransRateGroupList";
    private const string MethodClientTransRateGroupExcelList    = "ClientTransRateGroupExcelList";
    private const string MethodClientTransRateList              = "ClientTransRateList";
    private const string MethodCarTruckExcel                    = "CarTruckExcel";
    private const string MethodCarTonExcel                      = "CarTonExcel";
    private const string MethodAddrList                         = "AddrList";
    private const string MethodAddrListExcel                    = "AddrListExcel";
    private const string MethodItemCodeList                     = "ItemCodeList";
    private const string MethodTransRateItemIns                 = "TransRateItemIns";
    private const string MethodTransRateItemUpd                 = "TransRateItemUpd";
    private const string MethodClientTransRateDel               = "ClientTransRateDel";
    private const string MethodClientList                       = "ClientList";
    private const string MethodConsignorList                    = "ConsignorList";


    ClientTransRateDasServices      objClientTransRateDasServices   = new ClientTransRateDasServices();
    ClientDasServices               objClientDasServices            = new ClientDasServices();
    ConsignorDasServices            objConsignorDasServices         = new ConsignorDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string      strSeqNo            = string.Empty;
    private string      strCenterCode       = string.Empty;
    private string      strClientCode       = string.Empty;
    private string      strConsignorCode    = string.Empty;
    private string      strAddrText         = string.Empty;
    private string      strRateType         = string.Empty;
    private string      strFromSido         = string.Empty;
    private string      strFromGugun        = string.Empty;
    private string      strFromDong         = string.Empty;
    private string      strFromAreaCode     = string.Empty;

    private string      strToSido           = string.Empty;
    private string      strToGugun          = string.Empty;
    private string      strToDong           = string.Empty;
    private string      strToAreaCode       = string.Empty;
    private string      strCarTonCode       = string.Empty;

    private string      strCarTypeCode      = string.Empty;
    private string      strSaleUnitAmt      = string.Empty;
    private string      strPurchaseUnitAmt  = string.Empty;
    private string      strFromYMD          = string.Empty;
    private string      strToYMD            = string.Empty;
    private string      strCodeType         = string.Empty;
    private string      strDelFlag          = string.Empty;
    private string      strClientName       = string.Empty;
    private string      strConsignorName    = string.Empty;
    private string      strUseFlag          = string.Empty;

    private             HttpContext          objHttpContext                  = null;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodClientTransRateGroupList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientTransRateGroupExcelList,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientTransRateList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarTruckExcel,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarTonExcel,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAddrList,                       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateItemIns,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateItemUpd,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodItemCodeList,                   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientTransRateDel,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAddrListExcel,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorList,                  MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ClientTransRateHandler");
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
            strSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "0");
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strConsignorCode        = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strAddrText             = Utils.IsNull(SiteGlobal.GetRequestForm("AddrText"), "");

            strRateType             = Utils.IsNull(SiteGlobal.GetRequestForm("RateType"), "0");
            strFromSido             = Utils.IsNull(SiteGlobal.GetRequestForm("FromSido"), "");
            strFromGugun            = Utils.IsNull(SiteGlobal.GetRequestForm("FromGugun"), "");
            strFromDong             = Utils.IsNull(SiteGlobal.GetRequestForm("FromDong"), "");
            strFromAreaCode         = Utils.IsNull(SiteGlobal.GetRequestForm("FromAreaCode"), "");

            strToSido               = Utils.IsNull(SiteGlobal.GetRequestForm("ToSido"), "");
            strToGugun              = Utils.IsNull(SiteGlobal.GetRequestForm("ToGugun"), "");
            strToDong               = Utils.IsNull(SiteGlobal.GetRequestForm("ToDong"), "");
            strToAreaCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ToAreaCode"), "");
            strCarTonCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CarTonCode"), "");

            strCarTypeCode          = Utils.IsNull(SiteGlobal.GetRequestForm("CarTypeCode"), "");
            strSaleUnitAmt          = Utils.IsNull(SiteGlobal.GetRequestForm("SaleUnitAmt"), "-1").Replace(",", "");
            if (strSaleUnitAmt.Equals("-")) {
                strSaleUnitAmt = "-1";
            }
            strPurchaseUnitAmt      = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseUnitAmt"), "0");
            if (strPurchaseUnitAmt.Equals("-"))
            {
                strPurchaseUnitAmt = "-1";
            }
            strFromYMD              = Utils.IsNull(SiteGlobal.GetRequestForm("FromYMD"), "");
            strToYMD                = Utils.IsNull(SiteGlobal.GetRequestForm("ToYMD"), "");
            strCodeType             = Utils.IsNull(SiteGlobal.GetRequestForm("CodeType"), "");
            strDelFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("DelFlag"), "");
            strClientName           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            strConsignorName        = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
            strUseFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
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
                case MethodClientTransRateGroupList:
                    GetClientTransRateGroupList();
                    break;
                case MethodClientTransRateGroupExcelList:
                    GetClientTransRateGroupExcelList();
                    break;
                case MethodClientTransRateList:
                    GetClientTransRateList();
                    break;
                case MethodCarTruckExcel:
                    GetCarTruckExcel();
                    break;
                case MethodCarTonExcel:
                    GetCarTonExcel();
                    break;
                case MethodAddrList:
                    GetAddrList();
                    break;
                case MethodTransRateItemIns:
                    GetTransRateItemIns();
                    break;
                case MethodTransRateItemUpd:
                    GetTransRateItemUpd();
                    break;
                case MethodItemCodeList:
                    GetItemList();
                    break;
                case MethodClientTransRateDel:
                    ClientTransRateDel();
                    break;
                case MethodAddrListExcel:
                    GetAddrListExcel();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodConsignorList:
                    GetConsignorList();
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

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 요율표 그룹 리스트
    /// </summary>
    protected void GetClientTransRateGroupList()
    {
        ReqClientTransRateList                      lo_objReqClientTransRateList = null;
        ServiceResult<ResClientTransRateList>       lo_objResClientTransRateList = null;

        try
        {
            lo_objReqClientTransRateList = new ReqClientTransRateList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                ConsignorName    = strConsignorName,
                DelFlag          = strDelFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientTransRateList    = objClientTransRateDasServices.GetClientTransRateGroupList(lo_objReqClientTransRateList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientTransRateList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetClientTransRateGroupExcelList() {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqClientTransRateList                      lo_objReqClientTransRateList = null;
        ServiceResult<ResClientTransRateList>       lo_objResClientTransRateList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqClientTransRateList = new ReqClientTransRateList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                DelFlag          = strDelFlag,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientTransRateList    = objClientTransRateDasServices.GetClientTransRateGroupList(lo_objReqClientTransRateList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("운송사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객사 코드",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("적요일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("요율표구분", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록건수", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최초등록자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최초등록일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정자", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("최종수정일", typeof(string)));

            foreach (var row in lo_objResClientTransRateList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.ClientCode, row.FromYMD, row.ClientName, row.ConsignorName
                                  ,row.RateTypeM, row.Cnt, row.RegAdminID, row.RegDate, row.UpdAdminID
                                  ,row.UpdDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "ClientTransRate"};

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

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 그룹 리스트
    /// </summary>
    protected void GetClientTransRateList()
    {
        ReqClientTransRateList                      lo_objReqClientTransRateList = null;
        ServiceResult<ResClientTransRateList>       lo_objResClientTransRateList = null;

        try
        {
            lo_objReqClientTransRateList = new ReqClientTransRateList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                DelFlag          = "N",
                FromYMD          = strFromYMD.Replace("-", ""),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientTransRateList    = objClientTransRateDasServices.GetClientTransRateList(lo_objReqClientTransRateList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientTransRateList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
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

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
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

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
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

        if (string.IsNullOrEmpty(strAddrText))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg = "필요한 값이 없습니다.";
            return;
        }

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
        string lo_strGroupName = string.Empty;
        DataTable lo_objLocationCodeTable = null;

        try
        {

            lo_objLocationCodeTable = Utils.GetItemList(objHttpContext, strCodeType, objSes.AccessCenterCode, objSes.AdminID, out lo_strGroupName);
            if (lo_objLocationCodeTable != null)
            {
                objResMap.Add("LocationCode", lo_objLocationCodeTable.Rows.OfType<DataRow>().Select(dr => new {
                    ItemFullCode = dr.Field<string>("ItemFullCode"),
                    ItemName   = dr.Field<string>("ItemName")
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

    protected void GetTransRateItemIns() {
        ClientTransRateModel            lo_objReqClientTransRateIns = null;
        ServiceResult<bool>             lo_objResClientTransRateIns = null;
        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[화주코드]";
            return;
        }

        try
        {
            lo_objReqClientTransRateIns = new ClientTransRateModel
            {
                CenterCode              = strCenterCode.ToInt(),
                ClientCode              = strClientCode.ToInt(),
                ConsignorCode           = strConsignorCode.ToInt(),
                RateType                = strRateType.ToInt(),
                FromSido                = strFromSido,

                FromGugun               = strFromGugun,
                FromDong                = strFromDong,
                FromAreaCode            = strFromAreaCode,
                ToSido                  = strToSido,
                ToGugun                 = strToGugun,

                ToDong                  = strToDong,
                ToAreaCode              = strToAreaCode,
                CarTonCode              = strCarTonCode,
                CarTypeCode             = strCarTypeCode,
                SaleUnitAmt             = strSaleUnitAmt.ToInt(),

                PurchaseUnitAmt         = strPurchaseUnitAmt.ToInt(),
                FromYMD                 = strFromYMD,
                ToYMD                   = "29991231",
                AdminID                 = objSes.AdminID
            };

            lo_objResClientTransRateIns    = objClientTransRateDasServices.InsTransRateItem(lo_objReqClientTransRateIns);
            objResMap.RetCode  = lo_objResClientTransRateIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientTransRateIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9607;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetTransRateItemUpd() {
        ClientTransRateModel            lo_objReqClientTransRateIns = null;
        ServiceResult<bool>             lo_objResClientTransRateIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[화주코드]";
            return;
        }
        if (string.IsNullOrWhiteSpace(strSeqNo))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[일련번호]";
            return;
        }

        try
        {
            lo_objReqClientTransRateIns = new ClientTransRateModel
            {
                SeqNo                   = strSeqNo.ToInt(),
                CenterCode              = strCenterCode.ToInt(),
                ClientCode              = strClientCode.ToInt(),
                ConsignorCode           = strConsignorCode.ToInt(),
                RateType                = strRateType.ToInt(),
                FromSido                = strFromSido,

                FromGugun               = strFromGugun,
                FromDong                = strFromDong,
                FromAreaCode            = strFromAreaCode,
                ToSido                  = strToSido,
                ToGugun                 = strToGugun,

                ToDong                  = strToDong,
                ToAreaCode              = strToAreaCode,
                CarTonCode              = strCarTonCode,
                CarTypeCode             = strCarTypeCode,
                SaleUnitAmt             = strSaleUnitAmt.ToInt(),

                PurchaseUnitAmt         = strPurchaseUnitAmt.ToInt(),
                FromYMD                 = strFromYMD,
                ToYMD                   = "29991231",
                DelFlag                 = strDelFlag,
                AdminID                 = objSes.AdminID
            };

            lo_objResClientTransRateIns    = objClientTransRateDasServices.UpdTransRateItem(lo_objReqClientTransRateIns);
            objResMap.RetCode  = lo_objResClientTransRateIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientTransRateIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9607;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void ClientTransRateDel() {
        ClientTransRateModel            lo_objReqClientTransRateIns = null;
        ServiceResult<bool>             lo_objResClientTransRateIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[화주코드]";
            return;
        }

        try
        {
            lo_objReqClientTransRateIns = new ClientTransRateModel
            {
                CenterCode              = strCenterCode.ToInt(),
                ClientCode              = strClientCode.ToInt(),
                ConsignorCode           = strConsignorCode.ToInt(),
                RateType                = strRateType.ToInt(),
                FromYMD                 = strFromYMD,
                AdminID                 = objSes.AdminID
            };

            lo_objResClientTransRateIns    = objClientTransRateDasServices.DelTransRateItem(lo_objReqClientTransRateIns);
            objResMap.RetCode  = lo_objResClientTransRateIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientTransRateIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9607;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9608;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientTransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    /// <summary>
    /// 화주 목록
    /// </summary>
    protected void GetConsignorList()
    {
        ReqConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResConsignorList> lo_objResConsignorList = null;

        try
        {
            lo_objReqConsignorList = new ReqConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = strUseFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorList = objConsignorDasServices.GetConsignorList(lo_objReqConsignorList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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