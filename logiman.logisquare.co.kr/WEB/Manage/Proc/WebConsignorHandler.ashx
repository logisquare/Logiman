<%@ WebHandler Language="C#" Class="WebConsignorHandler" %>
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
/// FileName        : WebConsignorHandler.ashx
/// Description     : 화주 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : jylee88@logislab.com, 2022-07-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WebConsignorHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/WEB/Manage/WebConsignorList"; //필수

    // 메소드 리스트
    private const string MethodWebConsignorList         = "WebConsignorList";
    private const string MethodWebConsignorExcelList    = "WebConsignorExcelList";
    private const string MethodConsignorIns        = "ConsignorInsert";
    private const string MethodConsignorUpd        = "ConsignorUpdate";
    private const string MethodClientList          = "ClientList";
    private const string MethodClientConsignorList = "ClientConsignorList";
    private const string MethodClientConsignorIns  = "ClientConsignorInsert";
    private const string MethodClientConsignorDel  = "ClientConsignorDelete";
    WebOrderDasServices objWebOrderDasServices     = new WebOrderDasServices();
    ClientDasServices   objClientDasServices       = new ClientDasServices();
    private HttpContext  objHttpContext            = null;

    private string strCallType      = string.Empty;
    private int    intPageSize      = 0;
    private int    intPageNo        = 0;
    private string strConsignorCode = string.Empty;
    private string strCenterCode    = string.Empty;
    private string strConsignorName = string.Empty;
    private string strConsignorNote = string.Empty;
    private string strUseFlag       = string.Empty;
    private string strClientCode    = string.Empty;
    private string strClientName    = string.Empty;
    private string strEncSeqNo      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodWebConsignorList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebConsignorExcelList,  MenuAuthType.All);
        objMethodAuthList.Add(MethodConsignorIns,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorUpd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientConsignorList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientConsignorIns,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientConsignorDel,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("WebConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WebConsignorHandler");
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
            strConsignorCode = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "0");
            strConsignorName = SiteGlobal.GetRequestForm("ConsignorName");
            strConsignorNote = SiteGlobal.GetRequestForm("ConsignorNote");
            strUseFlag       = SiteGlobal.GetRequestForm("UseFlag");
            strClientCode    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strEncSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("EncSeqNo"),   "");
            strClientName    = SiteGlobal.GetRequestForm("ClientName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebConsignorHandler", "Exception",
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
                case MethodWebConsignorList:
                    GetWebConsignorList();
                    break;
                case MethodWebConsignorExcelList:
                    GetWebConsignorExcelList();
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

            SiteGlobal.WriteLog("WebConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 고객사 화주 목록
    /// </summary>
    protected void GetWebConsignorList()
    {
        ReqWebConsignorList                lo_objReqWebConsignorList = null;
        ServiceResult<ResWebConsignorList> lo_objResWebConsignorList = null;

        try
        {
            lo_objReqWebConsignorList = new ReqWebConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,

                AccessCorpNo     = objSes.AccessCorpNo,
                UseFlag          = strUseFlag,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResWebConsignorList = objWebOrderDasServices.GetWebConsignorList(lo_objReqWebConsignorList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResWebConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 화주 엑셀 목록
    /// </summary>
    protected void GetWebConsignorExcelList()
    {
        ReqWebConsignorList                lo_objReqWebConsignorList = null;
        ServiceResult<ResWebConsignorList> lo_objResWebConsignorList = null;
        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqWebConsignorList = new ReqWebConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,

                AccessCorpNo     = objSes.AccessCorpNo,
                UseFlag          = strUseFlag,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResWebConsignorList = objWebOrderDasServices.GetWebConsignorList(lo_objReqWebConsignorList);
            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용여부",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록ID",         typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("등록일",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정ID",             typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정일",             typeof(string)));

            foreach (var row in lo_objResWebConsignorList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.ConsignorName, row.ConsignorNote, row.UseFlag, row.RegAdminID
                                  ,row.RegDate, row.UpdAdminID, row.UpdDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "고객사 화주정보"};

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

            SiteGlobal.WriteLog("WebConsignorHandler", "Exception",
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