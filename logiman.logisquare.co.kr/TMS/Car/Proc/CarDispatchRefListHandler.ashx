<%@ WebHandler Language="C#" Class="CarDispatchRefListHandler" %>
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
/// FileName        : CarDispatchRefListHandler.ashx
/// Description     : 차량현황 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-07
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CarDispatchRefListHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Car/CarDispatchRefList"; //필수

    // 메소드 리스트
    private const string   MethodCarDispatchList           = "CarDispatchList";           //차량업체 조회
    private const string   MethodCarDispatchCooperatorList = "CarDispatchCooperatorList"; //협력업체 조회
    private const string   MethodCarDispatchExcelList      = "CarDispatchExcelList";
    CarDispatchDasServices objCarDispatchDasServices       = new CarDispatchDasServices();

    private string strCallType       = string.Empty;
    private int    intPageSize       = 0;
    private int    intPageNo         = 0;
    private int    intCenterCode     = 0;
    private string strUseFlag        = string.Empty;
    private string strComName        = string.Empty;
    private string strComCorpNo      = string.Empty;
    private int    intCarDivType     = 0;
    private string strCarNo          = string.Empty;
    private string strDriverName     = string.Empty;
    private string strDriverCell     = string.Empty;
    private string strCooperatorFlag = string.Empty;
    private string strCargoManFlag   = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCarDispatchList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchCooperatorList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchExcelList,      MenuAuthType.ReadOnly);

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
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CarDispatchListHandler");
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
            //CarDispatchList Parameter
            intCenterCode     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),     "0").ToInt();
            strUseFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"),        "");
            strComName        = Utils.IsNull(SiteGlobal.GetRequestForm("ComName"),        "");
            strComCorpNo      = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),      "");
            intCarDivType     = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"),     "0").ToInt();
            strCarNo          = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),          "");
            strDriverName     = Utils.IsNull(SiteGlobal.GetRequestForm("DriverName"),     "");
            strDriverCell     = Utils.IsNull(SiteGlobal.GetRequestForm("DriverCell"),     "");
            strCooperatorFlag = Utils.IsNull(SiteGlobal.GetRequestForm("CooperatorFlag"), "");
            strCargoManFlag   = Utils.IsNull(SiteGlobal.GetRequestForm("CargoManFlag"),   "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
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
                case MethodCarDispatchList:
                    GetCarDispatchRefList();
                    break;
                case MethodCarDispatchCooperatorList:
                    GetCarDispatchCooperatorList();
                    break;
                case MethodCarDispatchExcelList:
                    GetDispatchRefListExcel();
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

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 차량업체 엑셀 다운로드
    /// </summary>
    protected void GetDispatchRefListExcel()
    {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;
        string                            lo_strFileName           = "";
        SpreadSheet                       lo_objExcel              = null;
        DataTable                         lo_dtData                = null;
        MemoryStream                      lo_outputStream          = null;
        byte[]                            lo_Content               = null;
        int                               lo_intColumnIndex        = 0;

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                CenterCode       = intCenterCode,
                UseFlag          = strUseFlag,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                CarDivType       = intCarDivType,
                GradeCode        = objSes.GradeCode,
                CooperatorFlag   = strCooperatorFlag,
                CargoManFlag     = strCargoManFlag,
                CarNo            = strCarNo,
                DriverName       = strDriverName, 
                DriverCell       = strDriverCell,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCarDispatchList    = objCarDispatchDasServices.GetCarDispatchList(lo_objReqCarDispatchList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량구분",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차종",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("대표자",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("전화번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("팩스번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("협력업체", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("카고맨",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험대상", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정자",  typeof(string)));

            foreach (var row in lo_objResCarDispatchList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.CarDivTypeM, row.CarNo,row.CarTypeCodeM, row.CarTonCodeM
                                  ,row.DriverName, row.DriverCell, row.ComCorpNo, row.ComName, row.ComCeoName
                                  ,row.ComTelNo, row.ComFaxNo, row.CooperatorFlag, row.CargoManFlag, row.InsureTargetFlag
                                  , row.RefUseFlag, row.UpdDate, row.UpdAdminID);
            }

            lo_objExcel = new SpreadSheet {SheetName = "CarDispatchRefList"};

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
            objResMap.RetCode = 9511;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 항목 그룹 목록
    /// </summary>
    protected void GetCarDispatchRefList()
    {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                CenterCode       = intCenterCode,
                UseFlag          = strUseFlag,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                CarDivType       = intCarDivType,
                GradeCode        = objSes.GradeCode,
                CooperatorFlag   = strCooperatorFlag,
                CargoManFlag     = strCargoManFlag,
                CarNo            = strCarNo,
                DriverName       = strDriverName, 
                DriverCell       = strDriverCell,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCarDispatchList    = objCarDispatchDasServices.GetCarDispatchList(lo_objReqCarDispatchList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 항목 그룹 목록
    /// </summary>
    protected void GetCarDispatchCooperatorList()
    {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                CenterCode      = intCenterCode,
                UseFlag         = strUseFlag,
                ComName         = strComName,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objResCarDispatchList    = objCarDispatchDasServices.GetCarDispatchCooperatorList(lo_objReqCarDispatchList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
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