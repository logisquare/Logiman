<%@ WebHandler Language="C#" Class="InoutGMHandler" %>
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
using System.Web;
using Newtonsoft.Json;
using DataTable = System.Data.DataTable;

///================================================================
/// <summary>
/// FileName        : InoutGMHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-20
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutGMHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Inout/InoutGMList"; //필수

    // 메소드 리스트
    private const string MethodInoutGMList          = "InoutGMList";          //GM 오더 내역
    private const string MethodInoutGMListExcel     = "InoutGMListExcel";     //GM 오더 내역 엑셀
    private const string MethodInoutGMOrderIns      = "InoutGMOrderInsert";   //GM 오더 등록
    private const string MethodConsignorGMList      = "ConsignorGMList";      //GM 화주 목록
    private const string MethodConsignorGMListExcel = "ConsignorGMListExcel"; //GM 화주 목록 엑셀
    private const string MethodConsignorGMIns       = "ConsignorGMInsert";    //GM 화주 등록
    private const string MethodConsignorGMUpd       = "ConsignorGMUpdate";    //GM 화주 수정
    private const string MethodConsignorGMDel       = "ConsignorGMDelete";    //GM 화주 삭제
    private const string MethodConsignorList        = "ConsignorList";        //화주 조회
    private const string MethodClientList           = "ClientList";           //고객사(발주/청구처) 조회
    private const string MethodClientChargeList     = "ClientChargeList";     //고객사 담당자 조회
    private const string MethodPlaceList            = "PlaceList";            //상하차지 조회
    private const string MethodPlaceChargeList      = "PlaceChargeList";      //상하차지 담당자 조회

    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    ConsignorDasServices         objConsignorDasServices         = new ConsignorDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    private HttpContext          objHttpContext                  = null;

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strCenterCode                = string.Empty;
    private string strDateType                  = string.Empty;
    private string strDateFrom                  = string.Empty;
    private string strDateTo                    = string.Empty;
    private string strGMSeqNo                   = string.Empty;
    private string strConsignorCode             = string.Empty;
    private string strLocationAlias             = string.Empty;
    private string strShipper                   = string.Empty;
    private string strOrigin                    = string.Empty;
    private string strPickupPlace               = string.Empty;
    private string strPickupPlacePost           = string.Empty;
    private string strPickupPlaceAddr           = string.Empty;
    private string strPickupPlaceAddrDtl        = string.Empty;
    private string strPickupPlaceFullAddr       = string.Empty;
    private string strPickupPlaceChargeName     = string.Empty;
    private string strPickupPlaceChargePosition = string.Empty;
    private string strPickupPlaceChargeTelExtNo = string.Empty;
    private string strPickupPlaceChargeTelNo    = string.Empty;
    private string strPickupPlaceChargeCell     = string.Empty;
    private string strPickupPlaceLocalCode      = string.Empty;
    private string strPickupPlaceLocalName      = string.Empty;
    private string strConsignorName             = string.Empty;
    private string strClientCode                = string.Empty;
    private string strPlaceName                 = string.Empty;
    private string strPlant                     = string.Empty;
    private string strOrderClientCorpNos        = "1068159638"; //세바로지스틱스코리아
    private string strPayClientCorpNos          = "6018100739"; //인터지스
    //private string strOrderClientCorpNos        = "1908700380";
    //private string strPayClientCorpNos          = "1908700380";
    private string strClientName                = string.Empty;
    private string strChargeName                = string.Empty;
    private string strChargeBillFlag            = string.Empty;
    private string strClientFlag                = string.Empty;
    private string strChargeFlag                = string.Empty;
    private string strNation                    = string.Empty;
    private string strHawb                      = string.Empty;
    private string strMawb                      = string.Empty;
    private string strLength                    = string.Empty;
    private string strWidth                     = string.Empty;
    private string strHeight                    = string.Empty;
    private string strPTVolume                  = string.Empty;
    private string strCTVolume                  = string.Empty;
    private string strWeight                    = string.Empty;
    private string strCBM                       = string.Empty;
    private string strInvoiceNo                 = string.Empty;
    private string strNoteClient                = string.Empty;
    private string strOrderLocation             = string.Empty;
    private string strGMOrderType               = string.Empty;
    private string strNationKr                  = string.Empty;
    private string strOrderItemCode             = string.Empty;
    private string strPickupYMD                 = string.Empty;
    private string strPickupHM                  = string.Empty;
    private string strGetYMD                    = string.Empty;
    private string strGetHM                     = string.Empty;
    private string strOrderClientCode           = string.Empty;
    private string strOrderClientName           = string.Empty;
    private string strOrderClientChargeName     = string.Empty;
    private string strOrderClientChargePosition = string.Empty;
    private string strOrderClientChargeTelExtNo = string.Empty;
    private string strOrderClientChargeTelNo    = string.Empty;
    private string strOrderClientChargeCell     = string.Empty;
    private string strPayClientCode             = string.Empty;
    private string strPayClientName             = string.Empty;
    private string strPayClientChargeName       = string.Empty;
    private string strPayClientChargePosition   = string.Empty;
    private string strPayClientChargeTelExtNo   = string.Empty;
    private string strPayClientChargeTelNo      = string.Empty;
    private string strPayClientChargeCell       = string.Empty;
    private string strPayClientChargeLocation   = string.Empty;
    private string strGetPlace                  = string.Empty;
    private string strGetPlaceChargeName        = string.Empty;
    private string strGetPlaceChargePosition    = string.Empty;
    private string strGetPlaceChargeTelExtNo    = string.Empty;
    private string strGetPlaceChargeTelNo       = string.Empty;
    private string strGetPlaceChargeCell        = string.Empty;
    private string strGetPlacePost              = string.Empty;
    private string strGetPlaceAddr              = string.Empty;
    private string strGetPlaceAddrDtl           = string.Empty;
    private string strGetPlaceFullAddr          = string.Empty;
    private string strGetPlaceLocalCode         = string.Empty;
    private string strGetPlaceLocalName         = string.Empty;
    private string strPlaceChargeName           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodInoutGMList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutGMListExcel,     MenuAuthType.All);
        objMethodAuthList.Add(MethodInoutGMOrderIns,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorGMList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorGMListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodConsignorGMIns,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorGMUpd,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorGMDel,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceChargeList,      MenuAuthType.ReadOnly);
        
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

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutGMHandler");
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
            strCenterCode                = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType                  = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom                  = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                    = SiteGlobal.GetRequestForm("DateTo");
            strGMSeqNo                   = Utils.IsNull(SiteGlobal.GetRequestForm("GMSeqNo"),       "0");
            strConsignorCode             = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strLocationAlias             = SiteGlobal.GetRequestForm("LocationAlias");
            strShipper                   = SiteGlobal.GetRequestForm("Shipper");
            strOrigin                    = SiteGlobal.GetRequestForm("Origin");
            strPickupPlace               = SiteGlobal.GetRequestForm("PickupPlace");
            strPickupPlacePost           = SiteGlobal.GetRequestForm("PickupPlacePost");
            strPickupPlaceAddr           = SiteGlobal.GetRequestForm("PickupPlaceAddr");
            strPickupPlaceAddrDtl        = SiteGlobal.GetRequestForm("PickupPlaceAddrDtl");
            strPickupPlaceFullAddr       = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strPickupPlaceChargeName     = SiteGlobal.GetRequestForm("PickupPlaceChargeName");
            strPickupPlaceChargePosition = SiteGlobal.GetRequestForm("PickupPlaceChargePosition");
            strPickupPlaceChargeTelExtNo = SiteGlobal.GetRequestForm("PickupPlaceChargeTelExtNo");
            strPickupPlaceChargeTelNo    = SiteGlobal.GetRequestForm("PickupPlaceChargeTelNo");
            strPickupPlaceChargeCell     = SiteGlobal.GetRequestForm("PickupPlaceChargeCell");
            strPickupPlaceLocalCode      = SiteGlobal.GetRequestForm("PickupPlaceLocalCode");
            strPickupPlaceLocalName      = SiteGlobal.GetRequestForm("PickupPlaceLocalName");
            strConsignorName             = SiteGlobal.GetRequestForm("ConsignorName");
            strClientCode                = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strPlaceName                 = SiteGlobal.GetRequestForm("PlaceName");
            strPlant                     = SiteGlobal.GetRequestForm("Plant");
            strClientName                = SiteGlobal.GetRequestForm("ClientName");
            strChargeName                = SiteGlobal.GetRequestForm("ChargeName");
            strChargeBillFlag            = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag                = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag                = SiteGlobal.GetRequestForm("ChargeFlag");
            strNation                    = SiteGlobal.GetRequestForm("Nation");
            strHawb                      = SiteGlobal.GetRequestForm("Hawb");
            strMawb                      = SiteGlobal.GetRequestForm("Mawb");
            strLength                    = Utils.IsNull(SiteGlobal.GetRequestForm("Length"),   "0");
            strWidth                     = Utils.IsNull(SiteGlobal.GetRequestForm("Width"),    "0");
            strHeight                    = Utils.IsNull(SiteGlobal.GetRequestForm("Height"),   "0");
            strPTVolume                  = Utils.IsNull(SiteGlobal.GetRequestForm("PTVolume"), "0");
            strCTVolume                  = Utils.IsNull(SiteGlobal.GetRequestForm("CTVolume"), "0");
            strWeight                    = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"),   "0");
            strCBM                       = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"),      "0");
            strInvoiceNo                 = SiteGlobal.GetRequestForm("InvoiceNo");
            strNoteClient                = SiteGlobal.GetRequestForm("NoteClient");
            strOrderLocation             = SiteGlobal.GetRequestForm("OrderLocation");
            strGMOrderType               = SiteGlobal.GetRequestForm("GMOrderType");
            strNationKr                  = SiteGlobal.GetRequestForm("NationKr");
            strOrderItemCode             = SiteGlobal.GetRequestForm("OrderItemCode");
            strPickupYMD                 = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM                  = SiteGlobal.GetRequestForm("PickupHM");
            strGetYMD                    = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM                     = SiteGlobal.GetRequestForm("GetHM");
            strOrderClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"), "0");
            strOrderClientName           = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName     = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strOrderClientChargePosition = SiteGlobal.GetRequestForm("OrderClientChargePosition");
            strOrderClientChargeTelExtNo = SiteGlobal.GetRequestForm("OrderClientChargeTelExtNo");
            strOrderClientChargeTelNo    = SiteGlobal.GetRequestForm("OrderClientChargeTelNo");
            strOrderClientChargeCell     = SiteGlobal.GetRequestForm("OrderClientChargeCell");
            strPayClientCode             = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strPayClientName             = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName       = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargePosition   = SiteGlobal.GetRequestForm("PayClientChargePosition");
            strPayClientChargeTelExtNo   = SiteGlobal.GetRequestForm("PayClientChargeTelExtNo");
            strPayClientChargeTelNo      = SiteGlobal.GetRequestForm("PayClientChargeTelNo");
            strPayClientChargeCell       = SiteGlobal.GetRequestForm("PayClientChargeCell");
            strPayClientChargeLocation   = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strGetPlace                  = SiteGlobal.GetRequestForm("GetPlace");
            strGetPlaceChargeName        = SiteGlobal.GetRequestForm("GetPlaceChargeName");
            strGetPlaceChargePosition    = SiteGlobal.GetRequestForm("GetPlaceChargePosition");
            strGetPlaceChargeTelExtNo    = SiteGlobal.GetRequestForm("GetPlaceChargeTelExtNo");
            strGetPlaceChargeTelNo       = SiteGlobal.GetRequestForm("GetPlaceChargeTelNo");
            strGetPlaceChargeCell        = SiteGlobal.GetRequestForm("GetPlaceChargeCell");
            strGetPlacePost              = SiteGlobal.GetRequestForm("GetPlacePost");
            strGetPlaceAddr              = SiteGlobal.GetRequestForm("GetPlaceAddr");
            strGetPlaceAddrDtl           = SiteGlobal.GetRequestForm("GetPlaceAddrDtl");
            strGetPlaceFullAddr          = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strGetPlaceLocalCode         = SiteGlobal.GetRequestForm("GetPlaceLocalCode");
            strGetPlaceLocalName         = SiteGlobal.GetRequestForm("GetPlaceLocalName");
            strPlaceChargeName           = SiteGlobal.GetRequestForm("PlaceChargeName");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
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
                case MethodInoutGMList:
                    GetInoutGMList();
                    break;
                case MethodInoutGMListExcel:
                    GetInoutGMListExcel();
                    break;
                case MethodInoutGMOrderIns:
                    SetInoutGMOrderIns();
                    break;
                case MethodConsignorGMList:
                    GetConsignorGMList();
                    break;
                case MethodConsignorGMListExcel:
                    GetConsignorGMListExcel();
                    break;
                case MethodConsignorGMIns:
                    SetConsignorGMIns();
                    break;
                case MethodConsignorGMUpd:
                    SetConsignorGMUpd();
                    break;
                case MethodConsignorGMDel:
                    SetConsignorGMDel();
                    break;
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodPlaceChargeList:
                    GetPlaceChargeList();
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

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// GM 오더 내역
    /// </summary>
    protected void GetInoutGMList()
    {
        ReqGMOrderList                lo_objReqGMOrderList = null;
        ServiceResult<ResGMOrderList> lo_objResGMOrderList = null;

        try
        {
            lo_objReqGMOrderList = new ReqGMOrderList
            {
                CenterCode         = strCenterCode.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                Plant              = strPlant,
                LocationAlias      = strLocationAlias,
                Shipper            = strShipper,
                OrderClientCorpNos = strOrderClientCorpNos,
                PayClientCorpNos   = strPayClientCorpNos,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResGMOrderList = objOrderDasServices.GetGMOrderList(lo_objReqGMOrderList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResGMOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 오더 내역 엑셀
    /// </summary>
    protected void GetInoutGMListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqGMOrderList                lo_objReqGMOrderList = null;
        ServiceResult<ResGMOrderList> lo_objResGMOrderList = null;
        string                        lo_strFileName       = "";
        SpreadSheet                   lo_objExcel          = null;
        DataTable                     lo_dtData            = null;
        MemoryStream                  lo_outputStream      = null;
        byte[]                        lo_Content           = null;
        int                           lo_intColumnIndex    = 0;

        try
        {
            lo_objReqGMOrderList = new ReqGMOrderList
            {
                CenterCode         = strCenterCode.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                Plant              = strPlant,
                LocationAlias      = strLocationAlias,
                Shipper            = strShipper,
                OrderClientCorpNos = strOrderClientCorpNos,
                PayClientCorpNos   = strPayClientCorpNos,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResGMOrderList = objOrderDasServices.GetGMOrderList(lo_objReqGMOrderList);

            lo_dtData              = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("PICK UP DATE",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("PLANT",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("SO",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("MTI",            typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Location Alias", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Shipper",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Origin",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Length",         typeof(int)));

            lo_dtData.Columns.Add(new DataColumn("Width",          typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("Height",         typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("Pallet",         typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("Carton",         typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("GWT kg",         typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("Volume cbm",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("INV#",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Remark (CISCO)", typeof(string)));

            foreach (var row in lo_objResGMOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.PickupYMDHM,row.Nation,row.Hawb
                        ,row.Mawb,row.LocationAlias,row.Shipper,row.Origin,row.Length
                        ,row.Width,row.Height,row.PTVolume,row.CTVolume,row.Weight
                        ,row.CBM,row.InvoiceNo,row.NoteClient);
            }

            lo_objExcel = new SpreadSheet {SheetName = "GMOrderList"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 오더 등록
    /// </summary>
    protected void SetInoutGMOrderIns()
    {
        GMOrderModel                lo_objGMOrderModel  = null;
        ServiceResult<GMOrderModel> lo_objResGMOrderIns = null;
        int                         lo_intVolume        = 0;
        int                         lo_intWidth         = 0;
        int                         lo_intHeight        = 0;
        int                         lo_intLength        = 0;
        string                      lo_strQuantity      = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderLocation) || string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderClientCode) || strOrderClientCode.Equals("0") || string.IsNullOrWhiteSpace(strOrderClientName))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0") || string.IsNullOrWhiteSpace(strPayClientName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strLocationAlias) || string.IsNullOrWhiteSpace(strNation) || string.IsNullOrWhiteSpace(strShipper) || string.IsNullOrWhiteSpace(strOrigin))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strPickupYMD   =  string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strGetYMD      =  string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");
        lo_intVolume   =  !string.IsNullOrWhiteSpace(strCTVolume) && !strCTVolume.Equals("0") ? strCTVolume.ToInt() : strPTVolume.ToInt();
        lo_strQuantity =  !string.IsNullOrWhiteSpace(strCTVolume) && !strCTVolume.Equals("0") ? "C/T " : "P/T ";
        lo_intWidth    = (strWidth.ToDouble() * 0.1).ToInt();
        lo_intLength   = (strLength.ToDouble() * 0.1).ToInt();
        lo_intHeight   = (strHeight.ToDouble() * 0.1).ToInt();
        lo_strQuantity += lo_intLength + "*" + lo_intWidth + "*" + lo_intHeight + "*" + lo_intVolume;
        //strWeight = Math.Ceiling(strWeight.ToDouble()) + string.Empty;

        if (!string.IsNullOrWhiteSpace(strNationKr))
        {
            strNation = strNationKr + (string.IsNullOrWhiteSpace(strNation) ? string.Empty : " / ") + strNation;
        }
        
        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strGetYMD))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objGMOrderModel = new GMOrderModel
            {
                CenterCode                = strCenterCode.ToInt(),
                OrderLocation             = strOrderLocation,
                OrderItemCode             = strOrderItemCode,
                PickupYMD                 = strPickupYMD,
                PickupHM                  = strPickupHM,
                GetYMD                    = strGetYMD,
                GetHM                     = strGetHM,
                OrderClientCode           = strOrderClientCode.ToInt64(),
                OrderClientName           = strOrderClientName,
                OrderClientChargeName     = strOrderClientChargeName,
                OrderClientChargePosition = strOrderClientChargePosition,
                OrderClientChargeTelExtNo = strOrderClientChargeTelExtNo,
                OrderClientChargeTelNo    = strOrderClientChargeTelNo,
                OrderClientChargeCell     = strOrderClientChargeCell,
                PayClientCode             = strPayClientCode.ToInt64(),
                PayClientName             = strPayClientName,
                PayClientChargeName       = strPayClientChargeName,
                PayClientChargePosition   = strPayClientChargePosition,
                PayClientChargeTelExtNo   = strPayClientChargeTelExtNo,
                PayClientChargeTelNo      = strPayClientChargeTelNo,
                PayClientChargeCell       = strPayClientChargeCell,
                PayClientChargeLocation   = strPayClientChargeLocation,
                GetPlace                  = strGetPlace,
                GetPlaceChargeName        = strGetPlaceChargeName,
                GetPlaceChargePosition    = strGetPlaceChargePosition,
                GetPlaceChargeTelExtNo    = strGetPlaceChargeTelExtNo,
                GetPlaceChargeTelNo       = strGetPlaceChargeTelNo,
                GetPlaceChargeCell        = strGetPlaceChargeCell,
                GetPlacePost              = strGetPlacePost,
                GetPlaceAddr              = strGetPlaceAddr,
                GetPlaceAddrDtl           = strGetPlaceAddrDtl,
                GetPlaceFullAddr          = strGetPlaceFullAddr,
                GetPlaceLocalCode         = strGetPlaceLocalCode,
                GetPlaceLocalName         = strGetPlaceLocalName,
                NoteClient                = strNoteClient,
                Length                    = strLength.ToInt(),
                CBM                       = strCBM.ToDouble(),
                Quantity                  = lo_strQuantity,
                Volume                    = lo_intVolume,
                Weight                    = strWeight.ToDouble(),
                Nation                    = strNation,
                Hawb                      = strHawb,
                Mawb                      = strMawb,
                InvoiceNo                 = strInvoiceNo,
                GMOrderType               = strGMOrderType,
                GMTripID                  = string.Empty,
                LocationAlias             = strLocationAlias,
                Shipper                   = strShipper,
                Origin                    = strOrigin,
                RegAdminID                = objSes.AdminID,
                RegAdminName              = objSes.AdminName
            };

            lo_objResGMOrderIns = objOrderDasServices.SetGMOrderIns(lo_objGMOrderModel);
            objResMap.RetCode  = lo_objResGMOrderIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResGMOrderIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("OrderNo",    lo_objResGMOrderIns.data.OrderNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 화주 목록
    /// </summary>
    protected void GetConsignorGMList()
    {
        ReqConsignorGMList                lo_objReqConsignorGMList = null;
        ServiceResult<ResConsignorGMList> lo_objResConsignorGMList = null;

        try
        {
            lo_objReqConsignorGMList = new ReqConsignorGMList
            {
                GMSeqNo          = strGMSeqNo.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                LocationAlias    = strLocationAlias,
                Shipper          = strShipper,
                Origin           = strOrigin,
                DelFlag          = "N",
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResConsignorGMList = objConsignorDasServices.GetConsignorGMList(lo_objReqConsignorGMList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResConsignorGMList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 화주 목록 엑셀
    /// </summary>
    protected void GetConsignorGMListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqConsignorGMList                lo_objReqConsignorGMList = null;
        ServiceResult<ResConsignorGMList> lo_objResConsignorGMList = null;
        string                            lo_strFileName           = "";
        SpreadSheet                       lo_objExcel              = null;
        DataTable                         lo_dtData                = null;
        MemoryStream                      lo_outputStream          = null;
        byte[]                            lo_Content               = null;
        int                               lo_intColumnIndex        = 0;

        try
        {
            lo_objReqConsignorGMList = new ReqConsignorGMList
            {
                GMSeqNo          = strGMSeqNo.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                LocationAlias    = strLocationAlias,
                Shipper          = strShipper,
                Origin           = strOrigin,
                DelFlag          = "N",
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResConsignorGMList = objConsignorDasServices.GetConsignorGMList(lo_objReqConsignorGMList);

            lo_dtData              = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Location Alias",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Shipper",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Origin",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)우편번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소상세",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)담당자",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(상)직급",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록자명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정자명",   typeof(string)));

            foreach (var row in lo_objResConsignorGMList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.ConsignorName,row.LocationAlias,row.Shipper,row.Origin
                    ,row.PickupPlace,row.PickupPlacePost,row.PickupPlaceAddr,row.PickupPlaceAddrDtl,row.PickupPlaceChargeName
                    ,row.PickupPlaceChargePosition,row.PickupPlaceChargeTelExtNo,row.PickupPlaceChargeTelNo,row.PickupPlaceChargeCell,row.PickupPlaceLocalCode
                    ,row.PickupPlaceLocalName,row.RegDate,row.RegAdminName,row.UpdDate,row.UpdAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "ConsignorGMList"};

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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 화주 등록
    /// </summary>
    protected void SetConsignorGMIns()
    {
        ConsignorGMModel                lo_objConsignorGMModel  = null;
        ServiceResult<ConsignorGMModel> lo_objResConsignorGMIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strLocationAlias) || string.IsNullOrWhiteSpace(strOrigin) || string.IsNullOrWhiteSpace(strShipper))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupPlace) || string.IsNullOrWhiteSpace(strPickupPlaceChargeName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorGMModel = new ConsignorGMModel
            {
                CenterCode                = strCenterCode.ToInt(),
                ConsignorCode             = strConsignorCode.ToInt64(),
                LocationAlias             = strLocationAlias,
                Shipper                   = strShipper,
                Origin                    = strOrigin,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceLocalCode      = strPickupPlaceLocalCode,
                PickupPlaceLocalName      = strPickupPlaceLocalName,
                RegAdminID                = objSes.AdminID,
                RegAdminName              = objSes.AdminName
            };

            lo_objResConsignorGMIns = objConsignorDasServices.SetConsignorGMIns(lo_objConsignorGMModel);
            objResMap.RetCode  = lo_objResConsignorGMIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorGMIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("GMSeqNo",    lo_objResConsignorGMIns.data.GMSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 화주 수정
    /// </summary>
    protected void SetConsignorGMUpd()
    {
        ConsignorGMModel    lo_objConsignorGMModel  = null;
        ServiceResult<bool> lo_objResConsignorGMUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strLocationAlias) || string.IsNullOrWhiteSpace(strOrigin) || string.IsNullOrWhiteSpace(strShipper))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupPlace) || string.IsNullOrWhiteSpace(strPickupPlaceChargeName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGMSeqNo) || strGMSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorGMModel = new ConsignorGMModel
            {
                GMSeqNo                   = strGMSeqNo.ToInt64(),
                CenterCode                = strCenterCode.ToInt(),
                ConsignorCode             = strConsignorCode.ToInt64(),
                LocationAlias             = strLocationAlias,
                Shipper                   = strShipper,
                Origin                    = strOrigin,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceLocalCode      = strPickupPlaceLocalCode,
                PickupPlaceLocalName      = strPickupPlaceLocalName,
                UpdAdminID                = objSes.AdminID,
                UpdAdminName              = objSes.AdminName
            };

            lo_objResConsignorGMUpd = objConsignorDasServices.SetConsignorGMUpd(lo_objConsignorGMModel);
            objResMap.RetCode       = lo_objResConsignorGMUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorGMUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// GM 화주 삭제
    /// </summary>
    protected void SetConsignorGMDel()
    {
        ConsignorGMModel    lo_objConsignorGMModel  = null;
        ServiceResult<bool> lo_objResConsignorGMDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGMSeqNo) || strGMSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorGMModel = new ConsignorGMModel
            {
                GMSeqNo                   = strGMSeqNo.ToInt64(),
                CenterCode                = strCenterCode.ToInt(),
                DelAdminID                = objSes.AdminID,
                DelAdminName              = objSes.AdminName
            };

            lo_objResConsignorGMDel = objConsignorDasServices.SetConsignorGMDel(lo_objConsignorGMModel);
            objResMap.RetCode       = lo_objResConsignorGMDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorGMDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 목록 검색
    /// </summary>
    protected void GetConsignorList()
    {
        ReqConsignorSearchList                lo_objReqConsignorSearchList = null;
        ServiceResult<ResConsignorSearchList> lo_objResConsignorSearchList = null;

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

        try
        {
            lo_objReqConsignorSearchList = new ReqConsignorSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResConsignorSearchList = objConsignorDasServices.GetConsignorSearchList(lo_objReqConsignorSearchList);
            objResMap.strResponse        = "[" + JsonConvert.SerializeObject(lo_objResConsignorSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
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
                ChargeBillFlag   = strChargeBillFlag,
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

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 검색
    /// </summary>
    protected void GetClientChargeList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strChargeName))
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
                ClientCode       = strClientCode.ToInt(),
                UseFlag          = "Y",
                ChargeName       = strChargeName,
                ChargeUseFlag    = "Y",
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

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 검색
    /// </summary>
    protected void GetPlaceList()
    {
        ReqClientPlaceSearchList                lo_objReqClientPlaceSearchList = null;
        ServiceResult<ResClientPlaceSearchList> lo_objResClientPlaceSearchList = null;
        int                                     lo_intPageSize                 = 300;
        int                                     lo_intPageNo                   = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceSearchList = new ReqClientPlaceSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                PlaceName        = strPlaceName,
                UseFlag          = "Y",
                ChargeUseFlag    = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = lo_intPageSize,
                PageNo           = lo_intPageNo
            };
                
            lo_objResClientPlaceSearchList = objClientPlaceChargeDasServices.GetClientPlaceSearchList(lo_objReqClientPlaceSearchList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 담당자검색
    /// </summary>
    protected void GetPlaceChargeList()
    {
        ReqClientPlaceChargeSearchList                lo_objReqClientPlaceChargeSearchList = null;
        ServiceResult<ResClientPlaceChargeSearchList> lo_objResClientPlaceChargeSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceChargeName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeSearchList = new ReqClientPlaceChargeSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ChargeName       = strPlaceChargeName,
                UseFlag          = "Y",
                ChargeUseFlag    = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResClientPlaceChargeSearchList = objClientPlaceChargeDasServices.GetClientPlaceChargeSearchList(lo_objReqClientPlaceChargeSearchList);
            objResMap.strResponse                = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutGMHandler", "Exception",
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