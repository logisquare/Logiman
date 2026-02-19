<%@ WebHandler Language="C#" Class="DispatchHandler" %>
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
/// FileName        : DispatchHandler.ashx
/// Description     : 용차관리 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-05-15
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DispatchHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CarManage/DispatchList"; //필수

    // 메소드 리스트
    private const string MethodDispatchList          = "DispatchList";           //용차현황 목록
    private const string MethodDispatchListExcel     = "DispatchListExcel";      //용차현황 엑셀
        
    CarManageDasServices objCarManageDasServices = new CarManageDasServices();
    private HttpContext  objHttpContext          = null;

    private string strCallType   = string.Empty;
    private int    intPageSize   = 0;
    private int    intPageNo     = 0;
    private string strCenterCode = string.Empty;
    private string strDateType   = string.Empty;
    private string strDateFrom   = string.Empty;
    private string strDateTo     = string.Empty;
    private string strComName    = string.Empty;
    private string strComCorpNo  = string.Empty;
    private string strCarNo      = string.Empty;
    private string strDriverName = string.Empty;
    private string strDriverCell = string.Empty;
    private string strSearchType = string.Empty;
    private string strSearchText = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodDispatchList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDispatchListExcel, MenuAuthType.All);

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

            SiteGlobal.WriteLog("DispatchHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DispatchHandler");
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
            strCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType    = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom    = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo      = SiteGlobal.GetRequestForm("DateTo");
            strComName     = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo   = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo       = SiteGlobal.GetRequestForm("CarNo");
            strDriverName  = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell  = SiteGlobal.GetRequestForm("DriverCell");
            strSearchType  = SiteGlobal.GetRequestForm("SearchType");
            strSearchText  = SiteGlobal.GetRequestForm("SearchText");

            strDateFrom   = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo     = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DispatchHandler", "Exception",
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
                case MethodDispatchList:
                    GetDispatchList();
                    break;
                case MethodDispatchListExcel:
                    GetDispatchListExcel();
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

            SiteGlobal.WriteLog("DispatchHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    
    /// <summary>
    /// 용차현황 목록
    /// </summary>
    protected void GetDispatchList()
    {
        ReqDispatchList                lo_objReqDispatchList = null;
        ServiceResult<ResDispatchList> lo_objResDispatchList = null;

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strCarNo      = string.Empty;
        strDriverName = string.Empty;
        strDriverCell = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strCarNo = strSearchText;
                    break;
                case "2":
                    strDriverName = strSearchText;
                    break;
                case "3":
                    strDriverCell = strSearchText;
                    break;
            }
        }
        
        strComCorpNo  = string.IsNullOrWhiteSpace(strComCorpNo) ? strComCorpNo : strComCorpNo.Replace("-", string.Empty);
        strDriverCell = string.IsNullOrWhiteSpace(strDriverCell) ? strDriverCell : strDriverCell.Replace("-", string.Empty);

        try
        {
            lo_objReqDispatchList = new ReqDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                CarNo            = strCarNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                DispatchAdminID  = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };

            lo_objResDispatchList = objCarManageDasServices.GetDispatchList(lo_objReqDispatchList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DispatchHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 용차현황 목록 엑셀
    /// </summary>
    protected void GetDispatchListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;
            
        ReqDispatchList                lo_objReqDispatchList = null;
        ServiceResult<ResDispatchList> lo_objResDispatchList = null;
        string                         lo_strFileName        = "";
        SpreadSheet                    lo_objExcel           = null;
        DataTable                      lo_dtData             = null;
        MemoryStream                   lo_outputStream       = null;
        byte[]                         lo_Content            = null;
        int                            lo_intColumnIndex     = 0;

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strCarNo      = string.Empty;
        strDriverName = string.Empty;
        strDriverCell = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strCarNo = strSearchText;
                    break;
                case "2":
                    strDriverName = strSearchText;
                    break;
                case "3":
                    strDriverCell = strSearchText;
                    break;
            }
        }
        
        strComCorpNo  = string.IsNullOrWhiteSpace(strComCorpNo) ? strComCorpNo : strComCorpNo.Replace("-", string.Empty);
        strDriverCell = string.IsNullOrWhiteSpace(strDriverCell) ? strDriverCell : strDriverCell.Replace("-", string.Empty);
            
        try
        {
            
            lo_objReqDispatchList = new ReqDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                CarNo            = strCarNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                DispatchAdminID  = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };

            lo_objResDispatchList = objCarManageDasServices.GetDispatchList(lo_objReqDispatchList);

            lo_dtData             = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("배차건수", typeof(Int32)));
            lo_dtData.Columns.Add(new DataColumn("관리",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("톤수",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차종",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지적용주소", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("하차지적용주소", typeof(string)));

            foreach (var row in lo_objResDispatchList.data.list)
            {

                lo_dtData.Rows.Add(row.DispatchCnt, row.ManageFlag, row.CarNo, row.CarTonCodeM, row.CarTypeCodeM
                                , row.DriverName, row.DriverCell,row.ComName, row.ComCorpNo, row.PickupPlaceFullAddr
                                , row.GetPlaceFullAddr);

            }

            lo_objExcel = new SpreadSheet {SheetName = "CarManageDispatchList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);
                
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("DispatchHandler", "Exception",
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
            // ignored
        }
    }
}