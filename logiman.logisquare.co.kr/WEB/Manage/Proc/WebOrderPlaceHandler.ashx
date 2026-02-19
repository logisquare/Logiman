<%@ WebHandler Language="C#" Class="WebOrderPlaceHandler" %>
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
/// FileName        : WebOrderPlaceHandler.ashx
/// Description     : 상하차지 관련
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WebOrderPlaceHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/WEB/Manage/WebOrderPlaceList"; //필수

    // 메소드 리스트
    private const string MethodWebOrderPlaceChargeList      = "WebOrderPlaceChargeList";
    private const string MethodWebOrderPlaceExcelList       = "WebOrderPlaceExcelList";
    private const string MethodWebOrderPlaceInsert          = "WebOrderPlaceInsert";
    private const string MethodWebOrderPlaceUpdate          = "WebOrderPlaceUpdate";
    private const string MethodWebOrderPlaceList            = "WebOrderPlaceList";
    private const string MethodWebOrderPlaceChargeDelete    = "WebOrderPlaceChargeDelete";
    
    private const string MethodWebOrderChargeInsert         = "WebOrderChargeInsert";

    WebOrderDasServices               objWebOrderDasServices            = new WebOrderDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string      strCenterCode       = string.Empty;
    private string      strUseFlag          = string.Empty;
    private string      strSearchType       = string.Empty;
    private string      strSearchText       = string.Empty;

    private string      strPlaceSeqNo       = string.Empty;
    private string      strPlaceName        = string.Empty;
    private string      strPlacePost        = string.Empty;
    private string      strPlaceAddr        = string.Empty;
    private string      strPlaceAddrDtl     = string.Empty;
    private string      strChargeSeqNo      = string.Empty;
    private string      strChargeName       = string.Empty;
    private string      strChargePosition   = string.Empty;
    private string      strChargeTelExtNo   = string.Empty;
    private string      strChargeTelNo      = string.Empty;
    private string      strChargeCell       = string.Empty;
    private string      strChargeNote       = string.Empty;
    private string      strPlaceNote   = string.Empty;
    private string      strSido             = string.Empty;
    private string      strGugun            = string.Empty;
    private string      strDong             = string.Empty;
    private string      strFullAddr         = string.Empty;

    private string      strSeqNos1          = string.Empty;
    private string      strSeqNos2          = string.Empty;
    private string      strSeqNos3          = string.Empty;
    private string      strSeqNos4          = string.Empty;
    private string      strSeqNos5          = string.Empty;
    private string      strClientCode       = string.Empty;
    private string      strSeqNoType        = string.Empty;


    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodWebOrderPlaceChargeList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderPlaceExcelList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderPlaceInsert,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebOrderPlaceUpdate,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebOrderChargeInsert,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebOrderPlaceList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderPlaceChargeDelete,  MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WebOrderPlaceHandler");
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
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strPlaceSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "0");
            strUseFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");
            strSearchType           = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strSearchText           = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
            strPlaceName            = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceName"), "");
            strPlacePost            = Utils.IsNull(SiteGlobal.GetRequestForm("PlacePost"), "");
            strPlaceAddr            = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceAddr"), "");
            strPlaceAddrDtl         = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceAddrDtl"), "");
            strChargeSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeSeqNo"), "");
            strChargeName           = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeName"), "");
            strChargePosition       = Utils.IsNull(SiteGlobal.GetRequestForm("ChargePosition"), "");
            strChargeTelExtNo       = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeTelExtNo"), "");
            strChargeTelNo          = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeTelNo"), "");
            strChargeCell           = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeCell"), "");
            strChargeNote           = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeNote"), "");
            strPlaceNote            = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceNote"), "");
            strSeqNos1              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos1"), "");
            strSeqNos2              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos2"), "");
            strSeqNos3              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos3"), "");
            strSeqNos4              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos4"), "");
            strSeqNos5              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos5"), "");
            strSido                 = Utils.IsNull(SiteGlobal.GetRequestForm("Sido"), "");
            strGugun                = Utils.IsNull(SiteGlobal.GetRequestForm("Gugun"), "");
            strDong                 = Utils.IsNull(SiteGlobal.GetRequestForm("Dong"), "");
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strSeqNoType            = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNoType"), "1");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
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
                case MethodWebOrderPlaceChargeList:
                    GetWebOrderPlaceChargeList();
                    break;
                case MethodWebOrderPlaceExcelList:
                    GetWebOrderPlaceExcelList();
                    break;
                case MethodWebOrderPlaceInsert:
                    SetWebOrderPlaceInsert();
                    break;
                case MethodWebOrderPlaceUpdate:
                    SetWebOrderPlaceUpdate();
                    break;
                
                case MethodWebOrderChargeInsert:
                    GetWebOrderChargeInsert();
                    break;
                case MethodWebOrderPlaceList:
                    GetWebOrderPlaceList();
                    break;
                
                case MethodWebOrderPlaceChargeDelete:
                    GetWebOrderPlaceChargeDelete();
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

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 상하차지 + 담당자 목록
    /// </summary>
    protected void GetWebOrderPlaceChargeList()
    {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

        try
        {
            switch (strSearchType)
            {
                case "PlaceName":
                    lo_strPlaceName = strSearchText;
                    break;
                case "ChargeName":
                    lo_strChargeName = strSearchText;
                    break;
            }

            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                CenterCode       = strCenterCode.ToInt(),
                SeqNoType        = strSeqNoType.ToInt(),
                PlaceSeqNo       = strPlaceSeqNo.ToInt64(),
                UseFlag          = strUseFlag,
                PlaceName        = lo_strPlaceName,
                ChargeName       = lo_strChargeName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientPlaceChargeList    = objWebOrderDasServices.GetWebOrderPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량업체 엑셀 다운로드
    /// </summary>
    protected void GetWebOrderPlaceExcelList()
    {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            switch (strSearchType)
            {
                case "PlaceName":
                    lo_strPlaceName = strSearchText;
                    break;
                case "ChargeName":
                    lo_strChargeName = strSearchText;
                    break;
            }

            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                CenterCode       = strCenterCode.ToInt(),
                UseFlag          = strUseFlag,
                PlaceName        = lo_strPlaceName,
                ChargeName       = lo_strChargeName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientPlaceChargeList    = objWebOrderDasServices.GetWebOrderPlaceChargeList(lo_objReqClinetPlaceChargeList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("상하차지명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("담당자명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("내선",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전화번호", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("휴대폰", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("광역시,도", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시,군,구", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("읍,동,면", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용상태", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("등록일시", typeof(string)));

            foreach (var row in lo_objResClientPlaceChargeList.data.list)
            {
                lo_dtData.Rows.Add(row.PlaceName, row.PlaceAddr, row.ChargeName,row.ChargeTelExtNo, row.ChargeTelNo
                                  ,row.ChargeCell, row.Sido, row.Gugun, row.Dong, row.UseFlagM
                                  ,row.RegDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "GetDispatchRefList"};

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

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 상하차지 등록
    /// </summary>
    protected void SetWebOrderPlaceInsert() {
        ClientPlaceChargeViewModel                  lo_objReqClientPlaceChargeIns = null;
        ServiceResult<ClientPlaceChargeViewModel>   lo_objResClientPlaceChargeIns = null;
        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[상하차지명]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlacePost))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[우편번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceAddr))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[주소]";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeIns = new ClientPlaceChargeViewModel
            {
                CenterCode              = strCenterCode.ToInt(),
                ClientCorpNo            = objSes.AccessCorpNo,
                PlaceName               = strPlaceName,
                PlacePost               = strPlacePost,
                PlaceAddr               = strPlaceAddr,

                PlaceAddrDtl            = strPlaceAddrDtl,
                Sido                    = strSido,
                Gugun                   = strGugun,
                Dong                    = strDong,
                FullAddr                = strSido + " " + strGugun + " " + strDong,

                ChargeName              = strChargeName,
                ChargeTelNo             = strChargeTelNo,
                ChargeTelExtNo          = strChargeTelExtNo,
                ChargeCell              = strChargeCell,
                ChargeFaxNo             = null,

                ChargeEmail             = null,
                ChargePosition          = strChargePosition,
                ChargeDepartment        = null,
                ChargeNote              = strChargeNote,
                PlaceNote               = strPlaceNote,

                AdminID                 = objSes.AdminID,
                AdminName               = objSes.AdminName
            };

            lo_objResClientPlaceChargeIns    = objWebOrderDasServices.InsWebOrderPlace(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode  = lo_objResClientPlaceChargeIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
            else {
                objResMap.Add("PlaceSeqNo", lo_objResClientPlaceChargeIns.data.PlaceSeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 상하차지 수정
    /// </summary>
    protected void SetWebOrderPlaceUpdate() {
        ClientPlaceChargeViewModel                  lo_objReqClientPlaceChargeIns = null;
        ServiceResult<ClientPlaceChargeViewModel>   lo_objResClientPlaceChargeIns = null;
        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceSeqNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[일련번호]";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeIns = new ClientPlaceChargeViewModel
            {
                CenterCode              = strCenterCode.ToInt(),
                PlaceSeqNo              = strPlaceSeqNo.ToInt64(),
                PlaceAddrDtl            = strPlaceAddrDtl,
                PlaceNote               = strPlaceNote,
                UseFlag                 = strUseFlag,
                AdminID                 = objSes.AdminID,
                AdminName               = objSes.AdminName
            };

            lo_objResClientPlaceChargeIns    = objWebOrderDasServices.UpdWebOrderPlace(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode  = lo_objResClientPlaceChargeIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
            else {
                objResMap.Add("PlaceSeqNo", strPlaceSeqNo.ToInt64());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    //상하차지 담당자 등록
    protected void GetWebOrderChargeInsert() {
        ClientPlaceChargeViewModel        lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>               lo_objResClientPlaceChargeIns = null;
        if (string.IsNullOrWhiteSpace(strChargeName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[담당자명]";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeIns = new ClientPlaceChargeViewModel
            {
                PlaceSeqNo              = strPlaceSeqNo.ToInt(),
                ChargeName              = strChargeName,
                ChargeTelNo             = strChargeTelNo,
                ChargeTelExtNo          = strChargeTelExtNo,

                ChargeCell              = strChargeCell,
                ChargeFaxNo             = null,
                ChargeEmail             = null,
                ChargePosition          = strChargePosition,
                ChargeDepartment        = null,

                ChargeNote              = strChargeNote,
                AdminID                 = objSes.AdminID
            };

            lo_objResClientPlaceChargeIns    = objWebOrderDasServices.InsWebOrderPlaceCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode  = lo_objResClientPlaceChargeIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 불러오기
    /// </summary>
    protected void GetWebOrderPlaceList()
    {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

        try
        {
            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                PlaceSeqNo       = strPlaceSeqNo.ToInt(),
                PlaceName        = strPlaceName,
                CenterCode       = strCenterCode.ToInt(),
                GradeCode        = objSes.GradeCode,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientPlaceChargeList    = objWebOrderDasServices.GetWebOrderPlaceList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    //담당자 삭제    
    protected void GetWebOrderPlaceChargeDelete() {
        ClientPlaceChargeViewModel        lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>               lo_objResClientPlaceChargeIns = null;
        if (string.IsNullOrWhiteSpace(strPlaceSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeIns = new ClientPlaceChargeViewModel
            {
                CenterCode              = strCenterCode.ToInt(),
                PlaceSeqNo              = strPlaceSeqNo.ToInt(),
                SeqNos1                 = strSeqNos1,
                SeqNos2                 = strSeqNos2,
                SeqNos3                 = strSeqNos3,
                SeqNos4                 = strSeqNos4,
                SeqNos5                 = strSeqNos5,
                AdminID                 = objSes.AdminID
            };

            lo_objResClientPlaceChargeIns    = objWebOrderDasServices.DelWebOrderPlaceCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode  = lo_objResClientPlaceChargeIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebOrderPlaceHandler", "Exception",
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