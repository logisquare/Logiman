<%@ WebHandler Language="C#" Class="WebClosingHandler" %>
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
/// FileName        : WebClosingHandler.ashx
/// Description     : 웹오더 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-07
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WebClosingHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/WEB/Closing/WebClosingList"; //필수

    // 메소드 리스트
    private const string MethodOrderSaleClosingList   = "OrderSaleClosingList";   //청구내역 조회
    private const string MethodOrderClosingList       = "OrderClosingList";       //오더상세 내역 조회
    private const string MethodOrderClosingExcelList  = "OrderClosingExcelList";  //오더상세 내역 엑셀
    
    WebOrderDasServices objWebOrderDasServices = new WebOrderDasServices();
        
    private string strCallType         = string.Empty;
    private int    intPageSize         = 0;
    private int    intPageNo           = 0;
    private string strCenterCode       = string.Empty;
    private string strSaleClosingSeqNo = string.Empty;
    private string strDateType         = string.Empty;
    private string strDateFrom         = string.Empty;
    private string strDateTo           = string.Empty;
    private string strBillStatus       = string.Empty;
    private string strPGPayNo          = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderSaleClosingList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderClosingList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderClosingExcelList,  MenuAuthType.ReadOnly);
        
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

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WebClosingHandler");
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
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),       "0");
            strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            strDateType         = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),         "0");
            strDateFrom         = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo           = SiteGlobal.GetRequestForm("DateTo");
            strBillStatus       = Utils.IsNull(SiteGlobal.GetRequestForm("BillStatus"), "0");
            strPGPayNo          = Utils.IsNull(SiteGlobal.GetRequestForm("PGPayNo"),    "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
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
                case MethodOrderSaleClosingList:
                    CallOrderSaleClosingList();
                    break;
                case MethodOrderClosingList:
                    CallOrderClosingList();
                    break;
                case MethodOrderClosingExcelList:
                    CallOrderClosingExcelList();
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

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    ///청구내역
    /// </summary>
    protected void CallOrderSaleClosingList()
    {
        ReqOrderSaleClosingList                lo_objReqOrderSaleClosingList = null;
        ServiceResult<ResOrderSaleClosingList> lo_objResOrderSaleClosingList = null;
        
        try
        {
            lo_objReqOrderSaleClosingList = new ReqOrderSaleClosingList
            {
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom.Replace("-", ""),
                DateTo           = strDateTo.Replace("-", ""),
                BillStatus       = strBillStatus.ToInt(),
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResOrderSaleClosingList = objWebOrderDasServices.GetOrderSaleClosingClientList(lo_objReqOrderSaleClosingList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResOrderSaleClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
        
    /// <summary>
    /// 매출 전표 오더 목록
    /// </summary>
    protected void CallOrderClosingList()
    {
        ReqSaleClosingOrderList                lo_objReqSaleClosingOrderList = null;
        ServiceResult<ResSaleClosingOrderList> lo_objResSaleClosingOrderList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingOrderList = new ReqSaleClosingOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                AccessCenterCode = objSes.AccessCenterCode
            };
                
            lo_objResSaleClosingOrderList = objWebOrderDasServices.GetRequestSaleClosingOrderList(lo_objReqSaleClosingOrderList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResSaleClosingOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 오더 엑셀 다운로드
    /// </summary>
    protected void CallOrderClosingExcelList()
    {
        ReqSaleClosingOrderList                lo_objReqSaleClosingOrderList = null;
        ServiceResult<ResSaleClosingOrderList> lo_objResSaleClosingOrderList = null;
        string                                 lo_strFileName                = string.Empty;
        SpreadSheet                            lo_objExcel                   = null;
        DataTable                              lo_dtData                     = null;
        MemoryStream                           lo_outputStream               = null;
        byte[]                                 lo_Content                    = null;
        int                                    lo_intColumnIndex             = 0;
        
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingOrderList = new ReqSaleClosingOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResSaleClosingOrderList = objWebOrderDasServices.GetRequestSaleClosingOrderList(lo_objReqSaleClosingOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("접수번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처담당자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("목적국",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량(ea)",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총중량(kg)",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피(cbm)", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("화물정보",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송료",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",      typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("예수금",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("접수자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수일", typeof(string)));

            foreach (var row in lo_objResSaleClosingOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.OrderNo, row.OrderLocationCodeM, row.OrderItemCodeM, row.OrderClientName, row.OrderClientChargeName
                    , row.ConsignorName, row.PickupYMD, row.PickupPlace, row.GetYMD, row.GetPlace
                    , row.Nation, row.Volume, row.Weight, row.CBM, row.Quantity
                    , row.Hawb, row.Mawb, row.SaleSupplyAmt, row.SaleTaxAmt, row.AdvanceSupplyAmt3
                    , row.AdvanceSupplyAmt4, row.AcceptDate, row.AcceptAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "오더상세내역"};

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

            SiteGlobal.WriteLog("WebClosingHandler", "Exception",
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