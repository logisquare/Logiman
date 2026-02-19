<%@ WebHandler Language="C#" Class="OrderDispatchFpisHandler" %>
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
/// FileName        : OrderDispatchFpisHandler.ashx
/// Description     : 화물실적신고 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-02-13
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderDispatchFpisHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Dispatch/OrderDispatchList"; //필수

    // 메소드 리스트
    private const string MethodOrderFpisList      = "OrderFpisList";      //화물실적신고
    private const string MethodOrderFpisListExcel = "OrderFpisListExcel"; //화물실적신고 엑셀

    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();

    private HttpContext objHttpContext = null;

    private string strCallType                = string.Empty;
    private int    intPageSize                = 0;
    private int    intPageNo                  = 0;
    private string strCenterCode              = string.Empty;
    private string strDateFrom                = string.Empty;
    private string strDateTo                  = string.Empty;
    private string strCarNo                   = string.Empty;
    private string strClientName              = string.Empty;
    private string strOrderFPISFlag           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderFpisList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderFpisListExcel, MenuAuthType.All);

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

            SiteGlobal.WriteLog("OrderDispatchFpisHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderDispatchFpisHandler");
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
            strDateFrom                = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                  = SiteGlobal.GetRequestForm("DateTo");
            strCarNo                   = SiteGlobal.GetRequestForm("CarNo");
            strClientName              = SiteGlobal.GetRequestForm("ClientName");
            strOrderFPISFlag           = SiteGlobal.GetRequestForm("OrderFPISFlag");
                
            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchFpisHandler", "Exception",
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
                case MethodOrderFpisList:
                    GetOrderFpisList();
                    break;
                case MethodOrderFpisListExcel:
                    GetOrderFpisListExcel();
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

            SiteGlobal.WriteLog("OrderDispatchFpisHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 화물실적신고
    /// </summary>
    protected void GetOrderFpisList() 
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderClientName  = strClientName,
                CarNo            = strCarNo,
                AccessCenterCode = objSes.AccessCenterCode,
                OrderFPISFlag    = strOrderFPISFlag,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderFpisList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9709;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchFpisHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화물실적신고 엑셀
    /// </summary>
    protected void GetOrderFpisListExcel() 
    {
        SpreadSheet                         lo_objExcel        = null;
        DataTable                           lo_dtData          = null;
        MemoryStream                        lo_outputStream    = null;
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;
        string                              lo_strFileName     = string.Empty;
        byte[]                              lo_Content         = null;
        int                                 lo_intColumnIndex  = 0;

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderClientName  = strClientName,
                CarNo            = strCarNo,
                AccessCenterCode = objSes.AccessCenterCode,
                OrderFPISFlag    = strOrderFPISFlag,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResOrderList = objOrderDispatchDasServices.GetOrderFpisList(lo_objReqOrderList);
                
            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("사업자등록번호(운송의뢰자정보)", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계약고유번호",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계약년월",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계약금액",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이사화물/동일향만내이송",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("타운송수단 이용여부",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량등록번호",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송완료년월",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배차횟수",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송료",              typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("사업자등록번호(위탁계약정보)", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("위탁계약년월",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("위탁계약금액",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물정보망이용여부",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체명",             typeof(string)));

            foreach (var row in lo_objResOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.ClientCorpNo,row.OrderNo,row.PickupYMD,row.SaleAmt, "1"
                    ,"1",row.CarNo,row.PickupYMD,row.DispatchCnt,row.OrgAmt
                    ,row.ComCorpNo,row.PickupYMD,"0","N",row.ComName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "화물실적신고"};

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
            objResMap.RetCode = 9904;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchFpisHandler", "Exception",
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