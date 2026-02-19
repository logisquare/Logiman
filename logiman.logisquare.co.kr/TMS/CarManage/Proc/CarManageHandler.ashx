<%@ WebHandler Language="C#" Class="CarManageHandler" %>
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
/// FileName        : CarManageHandler.ashx
/// Description     : 관리차량 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-05-15
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CarManageHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CarManage/CarManageList"; //필수

    // 메소드 리스트
    private const string MethodCarManageList      = "CarManageList";      //관리차량 목록
    private const string MethodCarManageListExcel = "CarManageListExcel"; //관리차량 목록 엑셀
    private const string MethodAddrList           = "AddrList";           //주소 Json 불러오기
    private const string MethodCarManageIns       = "CarManageIns";       //관리차량 등록
    private const string MethodCarManageUpd       = "CarManageUpd";       //관리차량 수정
    private const string MethodCarManageDel       = "CarManageDel";       //관리차량 삭제
        
    CarManageDasServices objCarManageDasServices = new CarManageDasServices();
    private HttpContext  objHttpContext          = null;

    private string strCallType = string.Empty;
    private int    intPageSize = 0;
    private int    intPageNo   = 0;

    private string strCenterCode      = string.Empty;
    private string strAddrText        = string.Empty;
    private string strManageSeqNos    = string.Empty;
    private string strManageSeqNo     = string.Empty;
    private string strComCode         = string.Empty;
    private string strComName         = string.Empty;
    private string strComCorpNo       = string.Empty;
    private string strCarSeqNo        = string.Empty;
    private string strCarNo           = string.Empty;
    private string strCarTypeCode     = string.Empty;
    private string strCarTonCode      = string.Empty;
    private string strDriverSeqNo     = string.Empty;
    private string strDriverName      = string.Empty;
    private string strDriverCell      = string.Empty;
    private string strPickupFullAddr1 = string.Empty;
    private string strGetFullAddr1    = string.Empty;
    private string strPickupFullAddr2 = string.Empty;
    private string strGetFullAddr2    = string.Empty;
    private string strPickupFullAddr3 = string.Empty;
    private string strGetFullAddr3    = string.Empty;
    private string strDayInfo         = string.Empty;
    private string strEndYMDFlag      = string.Empty;
    private string strEndYMD          = string.Empty;
    private string strShareFlag       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCarManageList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodAddrList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageIns,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageUpd,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageDel,       MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CarManageHandler");
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
            strManageSeqNos    = SiteGlobal.GetRequestForm("ManageSeqNos");
            strManageSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("ManageSeqNo"), "0");
            strCenterCode      = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),  "0");
            strCarNo           = SiteGlobal.GetRequestForm("CarNo");
            strAddrText        = SiteGlobal.GetRequestForm("AddrText");
            strComCode         = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"), "0");
            strComName         = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo       = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarSeqNo        = Utils.IsNull(SiteGlobal.GetRequestForm("CarSeqNo"), "0");
            strCarTypeCode     = SiteGlobal.GetRequestForm("CarTypeCode");
            strCarTonCode      = SiteGlobal.GetRequestForm("CarTonCode");
            strDriverSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
            strDriverName      = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell      = Utils.IsNull(SiteGlobal.GetRequestForm("DriverCell"), "").Replace("-", "");
            strPickupFullAddr1 = SiteGlobal.GetRequestForm("PickupFullAddr1");
            strGetFullAddr1    = SiteGlobal.GetRequestForm("GetFullAddr1");
            strPickupFullAddr2 = SiteGlobal.GetRequestForm("PickupFullAddr2");
            strGetFullAddr2    = SiteGlobal.GetRequestForm("GetFullAddr2");
            strPickupFullAddr3 = SiteGlobal.GetRequestForm("PickupFullAddr3");
            strGetFullAddr3    = SiteGlobal.GetRequestForm("GetFullAddr3");
            strDayInfo         = SiteGlobal.GetRequestForm("DayInfo");
            strEndYMDFlag      = SiteGlobal.GetRequestForm("EndYMDFlag");
            strEndYMD          = Utils.IsNull(SiteGlobal.GetRequestForm("EndYMD"), "").Replace("-", "");
            strShareFlag       = SiteGlobal.GetRequestForm("ShareFlag");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
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
                
                case MethodCarManageList:
                    GetCarManageList();
                    break;
                case MethodCarManageListExcel:
                    GetCarManageListExcel();
                    break;
                case MethodAddrList:
                    GetAddrList();
                    break;
                case MethodCarManageIns:
                    SetCarManageIns();
                    break;
                case MethodCarManageUpd:
                    SetCarManageUpd();
                    break;
                case MethodCarManageDel:
                    SetCarManageDel();
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

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    

    /// <summary>
    /// 관리차량 현황 목록
    /// </summary>
    protected void GetCarManageList()
    {
        ReqCarManageList                lo_objReqCarManageList = null;
        ServiceResult<ResCarManageList> lo_objResCarManageList = null;

        if (strCenterCode.Equals("0") && (string.IsNullOrWhiteSpace(strCenterCode)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarManageList = new ReqCarManageList
            {
                CenterCode       = strCenterCode.ToInt(),
                ManageSeqNo      = strManageSeqNo.ToInt64(),
                CarNo            = strCarNo,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };
                
            lo_objResCarManageList = objCarManageDasServices.GetCarManageList(lo_objReqCarManageList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResCarManageList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 관리차량 목록 현황 엑셀 다운로드
    /// </summary>
    protected void GetCarManageListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqCarManageList                lo_objReqCarManageList = null;
        ServiceResult<ResCarManageList> lo_objResCarManageList = null;
        string                          lo_strFileName         = "";
        SpreadSheet                     lo_objExcel            = null;
        DataTable                       lo_dtData              = null;
        MemoryStream                    lo_outputStream        = null;
        byte[]                          lo_Content             = null;
        int                             lo_intColumnIndex      = 0;

        if (strCenterCode.Equals("0") && (string.IsNullOrWhiteSpace(strCenterCode)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        try
        {
            lo_objReqCarManageList = new ReqCarManageList
            {
                CenterCode       = strCenterCode.ToInt(),
                CarNo            = strCarNo,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };

            lo_objResCarManageList = objCarManageDasServices.GetCarManageList(lo_objReqCarManageList);

            lo_dtData              = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("배차건수", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("연락처",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("톤수",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차종",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("선택요일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("종료날짜", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지1", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지1", typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("상차지2", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지2", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지3", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지3", typeof(string)));

            foreach (var row in lo_objResCarManageList.data.list)
            {
                lo_dtData.Rows.Add(row.DispatchCnt, row.CarNo, row.DriverName, row.DriverCell, row.CarTonCodeM
                                , row.CarTypeCodeM, row.DayInfo,row.EndYMD, row.PickupFullAddr1, row.GetFullAddr1
                                , row.PickupFullAddr2, row.GetFullAddr2, row.PickupFullAddr3, row.GetFullAddr3);

            }

            lo_objExcel = new SpreadSheet {SheetName = "CarManageList"};

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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 주소 검색(메모리)
    /// </summary>
    protected void GetAddrList()
    {
        DataTable lo_dtList       = null;
        DataTable lo_dtListResult = null;

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

            lo_dtList = lo_dtList.Select("KKO_SIDO <> '' AND GUGUN <> '' AND KKO_FULLADDR LIKE '%" + strAddrText + "%' ", "KKO_FULLADDR ASC").CopyToDataTable();
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
                row["ADDR"] = row["KKO_FULLADDR"].ToString();
            }

            if (intPageSize > 0)
            {
                lo_dtListResult = lo_dtList.Rows.Count > intPageSize ? lo_dtList.AsEnumerable().Skip((intPageNo - 1) * intPageSize).Take(intPageSize).CopyToDataTable() : lo_dtList;
            }
            else
            {
                lo_dtListResult = lo_dtList;
            }
            
            objResMap.RetCode     = 0;
            objResMap.ErrMsg      = string.Empty;
            objResMap.strResponse = SiteGlobal.DataTableToRestJson(0, "OK", lo_dtListResult, lo_dtList.Rows.Count);
            objResMap.strResponse = "[" + objResMap.strResponse + "]";

        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "CarManageHandler",
                "Exception"
                , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9405);
        }
    }

    protected void SetCarManageIns()
    {
        CarManageGridModel                lo_objReqCarManageGridModel = null;
        ServiceResult<CarManageGridModel> lo_objResCarManageGridModel = null;

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[업체코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[차량일련번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[기사일련번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupFullAddr1))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[상차지 주소]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetFullAddr1))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[하차지 주소]";
            return;
        }

        try
        {
            lo_objReqCarManageGridModel = new CarManageGridModel
            {
                ComCode         = strComCode,
                ComName         = strComName,
                ComCorpNo       = strComCorpNo,
                CarSeqNo        = strCarSeqNo,
                CarNo           = strCarNo,
                CarTypeCode     = strCarTypeCode,
                CarTonCode      = strCarTonCode,
                DriverSeqNo     = strDriverSeqNo,
                DriverName      = strDriverName,
                DriverCell      = strDriverCell,
                PickupFullAddr1 = strPickupFullAddr1,
                GetFullAddr1    = strGetFullAddr1,
                PickupFullAddr2 = strPickupFullAddr2,
                GetFullAddr2    = strGetFullAddr2,
                PickupFullAddr3 = strPickupFullAddr3,
                GetFullAddr3    = strGetFullAddr3,
                DayInfo         = strDayInfo,
                EndYMDFlag      = strEndYMDFlag,
                EndYMD          = strEndYMD,
                ShareFlag       = strShareFlag,
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };
                
            lo_objResCarManageGridModel = objCarManageDasServices.SetCarManageIns(lo_objReqCarManageGridModel);
            objResMap.RetCode           = lo_objResCarManageGridModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarManageGridModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetCarManageUpd()
    {
        CarManageGridModel  lo_objReqCarManageGridModel = null;
        ServiceResult<bool> lo_objResCarManageGridModel = null;

        if (string.IsNullOrWhiteSpace(strManageSeqNo) || strManageSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[일련번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[업체코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[차량일련번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[기사일련번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupFullAddr1))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[상차지 주소]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetFullAddr1))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[하차지 주소]";
            return;
        }

        try
        {
            lo_objReqCarManageGridModel = new CarManageGridModel
            {
                ManageSeqNo     = strManageSeqNo,
                PickupFullAddr1 = strPickupFullAddr1,
                GetFullAddr1    = strGetFullAddr1,
                PickupFullAddr2 = strPickupFullAddr2,
                GetFullAddr2    = strGetFullAddr2,
                PickupFullAddr3 = strPickupFullAddr3,
                GetFullAddr3    = strGetFullAddr3,
                DayInfo         = strDayInfo,
                EndYMDFlag      = strEndYMDFlag,
                EndYMD          = strEndYMD,
                ShareFlag       = strShareFlag,
                UpdAdminID      = objSes.AdminID,
                UpdAdminName    = objSes.AdminName
            };

            lo_objResCarManageGridModel = objCarManageDasServices.SetCarManageUpd(lo_objReqCarManageGridModel);
            objResMap.RetCode           = lo_objResCarManageGridModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarManageGridModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetCarManageDel()
    {
        ReqCarManageDel     lo_objReqCarManageDel = null;
        ServiceResult<bool> lo_objResCarManageDel = null;
        
        if (string.IsNullOrWhiteSpace(strManageSeqNos))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[일련번호]";
            return;
        }
        
        try
        {
            lo_objReqCarManageDel = new ReqCarManageDel
            {
                ManageSeqNos = strManageSeqNos,
                DelAdminID   = objSes.AdminID
            };

            lo_objResCarManageDel = objCarManageDasServices.SetCarManageDel(lo_objReqCarManageDel);
            objResMap.RetCode     = lo_objResCarManageDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarManageDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarManageHandler", "Exception",
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