<%@ WebHandler Language="C#" Class="WebTransInoutHandler" %>
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

///================================================================
/// <summary>
/// FileName        : WebTransInoutHandler.ashx
/// Description     : 웹오더 솬련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-07
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WebTransInoutHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink                    = "/WEB/Manage/WebTransInoutList"; //필수

    // 메소드 리스트
    private const string MethodWebOrderList                 = "WebOrderList"; //웹오더 조회
    private const string MethodWebOrderExcelList            = "WebOrderExcelList"; //웹오더 엑셀다운로드
    private const string MethodOrderInoutIns                = "OrderInoutIns"; //입/출차관리

    WebOrderDasServices             objWebOrderDasServices              = new WebOrderDasServices();

    private string strCallType   = string.Empty;
    private int     intPageSize = 0;
    private int     intPageNo   = 0;

    private string  strCenterCode    = string.Empty;
    private string  strOrderNo       = string.Empty;
    private string  strSearchType    = string.Empty;
    private string  strSearchText    =  string.Empty;
    private string  strListType      =  string.Empty;
    private string  strDateType      =  string.Empty;
    private string  strDateFrom      =  string.Empty;
    private string  strDateTo        =  string.Empty;
    private string  strOrderStatus   =  string.Empty;
    private string  strConsignorName =  string.Empty;
    private string  strPickupPlace   =  string.Empty;
    private string  strGetPlace      =  string.Empty;
    private string  strGoodsName     =  string.Empty;
    private string  strMyOrderFlag   =  string.Empty;
    private string  strCnlFlag       =  string.Empty;
    private string  strOrderRegType  =  string.Empty;

    private string strDispatchSeqNo               = string.Empty;
    private string strInOutType                   = string.Empty;
    private string strInOutEtc                    = string.Empty;


    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodWebOrderList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderExcelList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderInoutIns,          MenuAuthType.ReadOnly);

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
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WebDomesticHandler");
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
            strCenterCode    =  Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo       =  Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strSearchType    =  Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strSearchText    =  Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
            strListType      =  Utils.IsNull(SiteGlobal.GetRequestForm("ListType"), "0");
            strDateType      =  Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom      =  Utils.IsNull(SiteGlobal.GetRequestForm("DateFrom"), "");
            strDateTo        =  Utils.IsNull(SiteGlobal.GetRequestForm("DateTo"), "");
            strOrderStatus   =  Utils.IsNull(SiteGlobal.GetRequestForm("OrderStatus"), "");
            strConsignorName =  Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
            strPickupPlace   =  Utils.IsNull(SiteGlobal.GetRequestForm("PickupPlace"), "");
            strGetPlace      =  Utils.IsNull(SiteGlobal.GetRequestForm("GetPlace"), "");
            strGoodsName     =  Utils.IsNull(SiteGlobal.GetRequestForm("GoodsName"), "");
            strMyOrderFlag   =  SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag       =  Utils.IsNull(SiteGlobal.GetRequestForm("CnlFlag"), "N");
            strOrderRegType  =  Utils.IsNull(SiteGlobal.GetRequestForm("OrderRegType"), "5");
            strDispatchSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strInOutType                    = Utils.IsNull(SiteGlobal.GetRequestForm("InOutType"), "0");
            strInOutEtc                     = Utils.IsNull(SiteGlobal.GetRequestForm("InOutEtc"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
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
                case MethodWebOrderList:
                    CallWebOrderList();
                    break;
                case MethodWebOrderExcelList:
                    GetWebOrderExcelList();
                    break;
                case MethodOrderInoutIns:
                    SetOrderInoutUpd();
                    break;
                default:
                    objResMap.RetCode = 9999;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 오더 엑셀 다운로드
    /// </summary>
    protected void GetWebOrderExcelList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                ListType        = strListType.ToInt(),
                DateType        = strDateType.ToInt(),
                DateFrom        = strDateFrom.Replace("-", ""),
                DateTo          = strDateTo.Replace("-", ""),
                OrderStatuses   = strOrderStatus,
                ConsignorName   = strConsignorName,
                PickupPlace     = strPickupPlace,
                GetPlace        = strGetPlace,
                GoodsName       = strGoodsName,
                OrderRegType    = strOrderRegType.ToInt(),
                AccessCenterCode    = objSes.AccessCenterCode,
                AccessCorpNo        = objSes.AccessCorpNo,
                MyOrderFlag         = strMyOrderFlag,
                CnlFlag             = strCnlFlag,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objWebResOrderList    = objWebOrderDasServices.GetWebOrderList(lo_objWebReqOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("오더상태",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지명",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차일",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지명",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차일",       typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("수량",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("중량",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량정보",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입차",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("출차",        typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("계류시간(분)",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",        typeof(string)));

            foreach (var row in lo_objWebResOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.OrderStatusM, row.PickupPlace, row.PickupYMD, row.GetPlace, row.GetYMD
                                  ,row.Volume, row.Weight, row.DispatchCarInfo1, row.InCarDt, row.OutCarDt
                                  ,row.MooringTime, row.InOutEtc);
            }

            lo_objExcel = new SpreadSheet {SheetName = "InoutDTList"};

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
            objResMap.RetCode = 9204;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 웹오더리스트
    /// </summary>
    protected void CallWebOrderList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "ConsignorName":
                    strConsignorName = strSearchText;
                    break;
                case "PickupPlace":
                    strPickupPlace = strSearchText;
                    break;
                case "GetPlace":
                    strGetPlace = strSearchText;
                    break;
                case "GoodsName":
                    strGoodsName = strSearchText;
                    break;
            }
        }
        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                ListType        = strListType.ToInt(),
                DateType        = strDateType.ToInt(),
                DateFrom        = strDateFrom.Replace("-", ""),
                DateTo          = strDateTo.Replace("-", ""),
                OrderStatuses   = strOrderStatus,
                ConsignorName   = strConsignorName,
                PickupPlace     = strPickupPlace,
                GetPlace        = strGetPlace,
                GoodsName       = strGoodsName,
                OrderRegType    = strOrderRegType.ToInt(),
                AccessCenterCode    = objSes.AccessCenterCode,
                AccessCorpNo        = objSes.AccessCorpNo,
                MyOrderFlag         = strMyOrderFlag,
                CnlFlag             = strCnlFlag,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objWebResOrderList    = objWebOrderDasServices.GetWebOrderList(lo_objWebReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objWebResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetOrderInoutUpd() {
        WebOrderModel                lo_objWebOrderModel        = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel     = null;

        if (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0"))
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

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                DispatchSeqNo             = strDispatchSeqNo.ToInt64(),
                CenterCode                = strCenterCode.ToInt(),
                InOutType                 = strInOutType.ToInt(),
                CnlFlag                   = strCnlFlag,
                InOutEtc                  = strInOutEtc,
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetOrderDispatchInOutUpd(lo_objWebOrderModel);
            objResMap.RetCode = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebDomesticHandler", "Exception",
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