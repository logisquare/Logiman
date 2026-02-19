<%@ WebHandler Language="C#" Class="PurchaseInsureHandler" %>
using System;
using System.Data;
using System.IO;
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : PurchaseInsureHandler.ashx
/// Description     : 산재보험현황현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-08-02
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseInsureHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseInsureList"; //필수
        
    // 메소드 리스트
    private const string MethodPurchaseInsureList      = "PurchaseInsureList";      //매입 전표 목록
    private const string MethodPurchaseInsureListExcel = "PurchaseInsureListExcel"; //매입 전표 엑셀
    private const string MethodSendKakaoDriver         = "SendKakaoDriver";         //주민번호수집 알림톡발송

    PurchaseDasServices    objPurchaseDasServices    = new PurchaseDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();
    private HttpContext    objHttpContext            = null;

    //private int    intPageSize    = 0;
    //private int    intPageNo      = 0;
    private string strCallType         = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strDateType         = string.Empty;
    private string strDateFrom         = string.Empty;
    private string strDateTo           = string.Empty;
    private string strComCorpNo        = string.Empty;
    private string strCarNo            = string.Empty;
    private string strDriverName       = string.Empty;
    private string strDriverCell       = string.Empty;
    private string strRefSeqNo         = string.Empty;
    private string strDriverSeqNo      = string.Empty;
    private string strInformationFlag  = string.Empty;
    private string strInsureExceptKind = string.Empty;
    
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPurchaseInsureList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseInsureListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodSendKakaoDriver,         MenuAuthType.ReadWrite);

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
            //intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            //intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseInsureHandler");
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
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType         = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom         = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo           = SiteGlobal.GetRequestForm("DateTo");
            strComCorpNo        = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo            = SiteGlobal.GetRequestForm("CarNo");
            strDriverName       = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell       = SiteGlobal.GetRequestForm("DriverCell");
            strRefSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),    "0");
            strDriverSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
            strInformationFlag  = SiteGlobal.GetRequestForm("InformationFlag");
            strInsureExceptKind = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "0");
            
            strDateFrom    = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo      = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
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
                case MethodPurchaseInsureList:
                    GetPurchaseInsureList();
                    break;;
                case MethodPurchaseInsureListExcel:
                    GetPurchaseInsureListExcel();
                    break;
                case MethodSendKakaoDriver:
                    SetSendKakaoDriver();
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

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 전표 목록
    /// </summary>
    protected void GetPurchaseInsureList()
    {
        ReqPurchaseInsureList                lo_objReqPurchaseInsureList = null;
        ServiceResult<ResPurchaseInsureList> lo_objResPurchaseInsureList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseInsureList = new ReqPurchaseInsureList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ComCorpNo        = strComCorpNo,
                CarNo            = strCarNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                InformationFlag  = strInformationFlag,
                InsureExceptKind = strInsureExceptKind.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResPurchaseInsureList = objPurchaseDasServices.GetPurchaseInsureList(lo_objReqPurchaseInsureList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseInsureList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 목록 엑셀
    /// </summary>
    protected void GetPurchaseInsureListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseInsureList                lo_objReqPurchaseInsureList = null;
        ServiceResult<ResPurchaseInsureList> lo_objResPurchaseInsureList = null;
        string                               lo_strFileName              = string.Empty;
        SpreadSheet                          lo_objExcel                 = null;
        DataTable                            lo_dtData                   = null;
        MemoryStream                         lo_outputStream             = null;
        byte[]                               lo_Content                  = null;
        int                                  lo_intColumnIndex           = 0;
        string                               lo_strDecPersonalNo         = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseInsureList = new ReqPurchaseInsureList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ComCorpNo        = strComCorpNo,
                CarNo            = strCarNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                InformationFlag  = strInformationFlag,
                InsureExceptKind = strInsureExceptKind.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResPurchaseInsureList = objPurchaseDasServices.GetPurchaseInsureList(lo_objReqPurchaseInsureList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("주민번호수집",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험신고", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("산재보험대상",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험적용",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송료(공급가액)", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("월보수액",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발행상태",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발행구분",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("작성일",      typeof(string)));
            if (objSes.PrivateAvailFlag.Equals("Y"))
            {
                lo_dtData.Columns.Add(new DataColumn("주민등록번호", typeof(string)));
            }

            if (objSes.PrivateAvailFlag.Equals("Y"))
            {
                
                foreach (var row in lo_objResPurchaseInsureList.data.list)
                {
                    lo_strDecPersonalNo = string.IsNullOrWhiteSpace(row.EncPersonalNo) ? string.Empty : Utils.GetDecrypt(row.EncPersonalNo);

                    lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.PickupYMD,row.GetYMD,row.ComCorpNo
                        ,row.CarNo,row.DriverName,row.DriverCell,row.InformationFlag,row.InsureExceptKindM
                        ,row.InsureTargetFlag,row.InsureFlag,row.SupplyAmt,row.TransAmt,row.PurchaseClosingSeqNo
                        ,row.BillStatusM,row.BillKindM,row.BillWrite,lo_strDecPersonalNo);
                }
            }
            else
            {
                foreach (var row in lo_objResPurchaseInsureList.data.list)
                {
                    lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.PickupYMD,row.GetYMD,row.ComCorpNo
                        ,row.CarNo,row.DriverName,row.DriverCell,row.InformationFlag,row.InsureExceptKindM
                        ,row.InsureTargetFlag,row.InsureFlag,row.SupplyAmt,row.TransAmt,row.PurchaseClosingSeqNo
                        ,row.BillStatusM,row.BillKindM,row.BillWrite);
                }
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "산재보험현황"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            if (objSes.PrivateAvailFlag.Equals("Y"))
            {
                lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            }

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

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 주민번호 수집 알림톡 발송
    /// </summary>
    protected void SetSendKakaoDriver()
    {
        CarDriverKakaoModel                lo_objReqCarDriverKakaoModel = null;
        ServiceResult<CarDriverKakaoModel> lo_objResCarDriverKakaoModel = null;
        int                                lo_intSendType               = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDriverKakaoModel = new CarDriverKakaoModel
            {
                CenterCode  = strCenterCode.ToInt(),
                SendType    = lo_intSendType,
                RefSeqNo    = strRefSeqNo.ToInt64(),
                DriverSeqNo = strDriverSeqNo.ToInt64(),
                RegAdminID  = objSes.AdminID
            };

            lo_objResCarDriverKakaoModel = objCarDispatchDasServices.SetCarDriverKakaoIns(lo_objReqCarDriverKakaoModel);
            objResMap.RetCode            = lo_objResCarDriverKakaoModel.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverKakaoModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseInsureHandler", "Exception",
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