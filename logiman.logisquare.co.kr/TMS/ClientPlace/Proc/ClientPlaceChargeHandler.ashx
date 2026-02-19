<%@ WebHandler Language="C#" Class="ClientPlaceChargeHandler" %>
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
/// FileName        : ClientPlaceChargeHandler.ashx
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
public class ClientPlaceChargeHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClientPlace/ClientPlaceChargeList"; //필수

    // 메소드 리스트
    private const string MethodClientPlaceChargeList      = "ClientPlaceChargeList";
    private const string MethodClientPlaceChargeExcelList = "ClientPlaceChargeExcelList";
    private const string MethodPlaceList                  = "PlaceList";
    private const string MethodChargeList                 = "ChargeList";
    private const string MethodClientPlaceChargeInsert    = "ClientPlaceChargeInsert";
    private const string MethodChargeInsert               = "ChargeInsert";
    private const string MethodChargeUpdate               = "ClientPlaceChargeUpdate";
    private const string MethodChargeDelete               = "ChargeDelete";
    private const string MethodClientList                 = "ClientList";

    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strCenterCode     = string.Empty;
    private string strClientCode     = string.Empty;
    private string strUseFlag        = string.Empty;
    private string strSearchType     = string.Empty;
    private string strSearchText     = string.Empty;
    private string strPlaceSeqNo     = string.Empty;
    private string strPlaceName      = string.Empty;
    private string strPlacePost      = string.Empty;
    private string strPlaceAddr      = string.Empty;
    private string strPlaceAddrDtl   = string.Empty;
    private string strChargeSeqNo    = string.Empty;
    private string strChargeName     = string.Empty;
    private string strChargePosition = string.Empty;
    private string strChargeTelExtNo = string.Empty;
    private string strChargeTelNo    = string.Empty;
    private string strChargeCell     = string.Empty;
    private string strChargeNote     = string.Empty;
    private string strLocalCode      = string.Empty;
    private string strLocalName      = string.Empty;
    private string strPlaceRemark1   = string.Empty;
    private string strPlaceRemark2   = string.Empty;
    private string strPlaceRemark3   = string.Empty;
    private string strPlaceRemark4   = string.Empty;
    private string strSido           = string.Empty;
    private string strGugun          = string.Empty;
    private string strDong           = string.Empty;
    private string strFullAddr       = string.Empty;
    private string strSeqNos1        = string.Empty;
    private string strSeqNos2        = string.Empty;
    private string strSeqNos3        = string.Empty;
    private string strSeqNos4        = string.Empty;
    private string strSeqNos5        = string.Empty;
    private string strClientName     = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodClientPlaceChargeList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientPlaceChargeExcelList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceList,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodChargeList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientPlaceChargeInsert,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodChargeInsert,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodChargeUpdate,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodChargeDelete,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,                 MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ClientPlaceChargeHandler");
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
            strCenterCode     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strPlaceSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "0");
            strUseFlag        = SiteGlobal.GetRequestForm("UseFlag");
            strSearchType     = SiteGlobal.GetRequestForm("SearchType");
            strSearchText     = SiteGlobal.GetRequestForm("SearchText");
            strPlaceName      = SiteGlobal.GetRequestForm("PlaceName");
            strPlacePost      = SiteGlobal.GetRequestForm("PlacePost");
            strPlaceAddr      = SiteGlobal.GetRequestForm("PlaceAddr");
            strPlaceAddrDtl   = SiteGlobal.GetRequestForm("PlaceAddrDtl");
            strChargeSeqNo    = SiteGlobal.GetRequestForm("ChargeSeqNo");
            strChargeName     = SiteGlobal.GetRequestForm("ChargeName");
            strChargePosition = SiteGlobal.GetRequestForm("ChargePosition");
            strChargeTelExtNo = SiteGlobal.GetRequestForm("ChargeTelExtNo");
            strChargeTelNo    = SiteGlobal.GetRequestForm("ChargeTelNo");
            strChargeCell     = SiteGlobal.GetRequestForm("ChargeCell");
            strChargeNote     = SiteGlobal.GetRequestForm("ChargeNote");
            strLocalCode      = SiteGlobal.GetRequestForm("LocalCode");
            strLocalName      = SiteGlobal.GetRequestForm("LocalName");
            strPlaceRemark1   = SiteGlobal.GetRequestForm("PlaceRemark1");
            strPlaceRemark2   = SiteGlobal.GetRequestForm("PlaceRemark2");
            strPlaceRemark3   = SiteGlobal.GetRequestForm("PlaceRemark3");
            strPlaceRemark4   = SiteGlobal.GetRequestForm("PlaceRemark4");
            strSeqNos1        = SiteGlobal.GetRequestForm("SeqNos1");
            strSeqNos2        = SiteGlobal.GetRequestForm("SeqNos2");
            strSeqNos3        = SiteGlobal.GetRequestForm("SeqNos3");
            strSeqNos4        = SiteGlobal.GetRequestForm("SeqNos4");
            strSeqNos5        = SiteGlobal.GetRequestForm("SeqNos5");
            strSido           = SiteGlobal.GetRequestForm("Sido");
            strGugun          = SiteGlobal.GetRequestForm("Gugun");
            strDong           = SiteGlobal.GetRequestForm("Dong");
            strClientName     = SiteGlobal.GetRequestForm("ClientName");
            strClientCode     = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
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
                case MethodClientPlaceChargeList:
                    GetClientPlaceChargeList();
                    break;
                case MethodClientPlaceChargeExcelList:
                    GetClientPlaceChargeExcelList();
                    break;
                case MethodClientPlaceChargeInsert:
                    ClientPlaceChargeIns();
                    break;
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodChargeList:
                    GetChargeList();
                    break;
                case MethodChargeInsert:
                    GetChargeInsert();
                    break;
                case MethodChargeDelete:
                    GetChargeDelete();
                    break;
                case MethodChargeUpdate:
                    GetChargeUpdate();
                    break;
                case MethodClientList:
                    GetClientList();
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

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 상하차지 + 담당자 목록
    /// </summary>
    protected void GetClientPlaceChargeList()
    {
        string                                  lo_strPlaceName                = string.Empty;
        string                                  lo_strChargeName               = string.Empty;
        ReqClientPlaceChargeList                lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList> lo_objResClientPlaceChargeList = null;

        try
        {
            switch (strSearchType)
            {
                case "PlaceName":
                    lo_strPlaceName = strSearchText;
                    break;
                case "PlaceNameSearch":
                    lo_strPlaceName = strSearchText;
                    break;
                case "ChargeName":
                    lo_strChargeName = strSearchText;
                    break;
            }

            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                UseFlag          = strUseFlag,
                PlaceName        = lo_strPlaceName,
                ChargeName       = lo_strChargeName,
                SearchType       = strSearchType,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResClientPlaceChargeList = objClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량업체 엑셀 다운로드
    /// </summary>
    protected void GetClientPlaceChargeExcelList()
    {
        string                                  lo_strPlaceName                = string.Empty;
        string                                  lo_strChargeName               = string.Empty;
        ReqClientPlaceChargeList                lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList> lo_objResClientPlaceChargeList = null;
        string                                  lo_strFileName                 = "";
        SpreadSheet                             lo_objExcel                    = null;
        DataTable                               lo_dtData                      = null;
        MemoryStream                            lo_outputStream                = null;
        byte[]                                  lo_Content                     = null;
        int                                     lo_intColumnIndex              = 0;

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
                CenterCode = strCenterCode.ToInt(),
                UseFlag    = strUseFlag,
                PlaceName  = lo_strPlaceName,
                ChargeName = lo_strChargeName,
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResClientPlaceChargeList    = objClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClinetPlaceChargeList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("상하차지명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("담당자명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("광역시,도", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시,군,구", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("읍,동,면", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("지역코드",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("지역명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록일시", typeof(string)));

            foreach (var row in lo_objResClientPlaceChargeList.data.list)
            {
                lo_dtData.Rows.Add(row.PlaceName, row.PlaceAddr, row.ChargeName,row.ChargeTelExtNo, row.ChargeTelNo
                                  ,row.ChargeCell, row.Sido, row.Gugun, row.Dong, row.LocalCode
                                  ,row.LocalName, row.UseFlagM, row.RegDate);
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

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 불러오기
    /// </summary>
    protected void GetPlaceList()
    {
        string                                  lo_strPlaceName                = string.Empty;
        string                                  lo_strChargeName               = string.Empty;
        ReqClientPlaceChargeList                lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList> lo_objResClientPlaceChargeList = null;

        try
        {
            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                PlaceSeqNo       = strPlaceSeqNo.ToInt64(),
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResClientPlaceChargeList = objClientPlaceChargeDasServices.GetClientPlaceList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 불러오기
    /// </summary>
    protected void GetChargeList()
    {
        string                                  lo_strPlaceName                = string.Empty;
        string                                  lo_strChargeName               = string.Empty;
        ReqClientPlaceChargeList                lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList> lo_objResClientPlaceChargeList = null;

        try
        {
            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                PlaceSeqNo       = strPlaceSeqNo.ToInt64(),
                ChargeName       = strChargeName,
                ChargeUseFlag    = "Y",
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResClientPlaceChargeList = objClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void ClientPlaceChargeIns() 
    {
        ClientPlaceChargeViewModel                lo_objReqClientPlaceChargeIns = null;
        ServiceResult<ClientPlaceChargeViewModel> lo_objResClientPlaceChargeIns = null;

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
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                PlaceName        = strPlaceName,
                PlacePost        = strPlacePost,
                PlaceAddr        = strPlaceAddr,
                PlaceAddrDtl     = strPlaceAddrDtl,
                Sido             = strSido,
                Gugun            = strGugun,
                Dong             = strDong,
                FullAddr         = strSido + " " + strGugun + " " + strDong,
                ChargeName       = strChargeName,
                ChargeTelNo      = strChargeTelNo,
                ChargeTelExtNo   = strChargeTelExtNo,
                ChargeCell       = strChargeCell,
                ChargeFaxNo      = null,
                ChargeEmail      = null,
                ChargePosition   = strChargePosition,
                ChargeDepartment = null,
                ChargeNote       = strChargeNote,
                LocalCode        = strLocalCode,
                LocalName        = strLocalName,
                PlaceRemark1     = strPlaceRemark1,
                PlaceRemark2     = strPlaceRemark2,
                PlaceRemark3     = strPlaceRemark3,
                PlaceRemark4     = strPlaceRemark4,
                AdminID          = objSes.AdminID
            };
                
            lo_objResClientPlaceChargeIns = objClientPlaceChargeDasServices.InsClientPlaceCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode             = lo_objResClientPlaceChargeIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
            else 
            {
                objResMap.Add("PlaceSeqNo", lo_objResClientPlaceChargeIns.data.PlaceSeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChargeInsert() 
    {
        ClientPlaceChargeViewModel lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>        lo_objResClientPlaceChargeIns = null;

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
                PlaceSeqNo       = strPlaceSeqNo.ToInt64(),
                ChargeName       = strChargeName,
                ChargeTelNo      = strChargeTelNo,
                ChargeTelExtNo   = strChargeTelExtNo,
                ChargeCell       = strChargeCell,
                ChargeFaxNo      = null,
                ChargeEmail      = null,
                ChargePosition   = strChargePosition,
                ChargeDepartment = null,
                ChargeNote       = strChargeNote,
                AdminID          = objSes.AdminID
            };
                
            lo_objResClientPlaceChargeIns = objClientPlaceChargeDasServices.InsCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode             = lo_objResClientPlaceChargeIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChargeDelete() 
    {
        ClientPlaceChargeViewModel lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>        lo_objResClientPlaceChargeIns = null;

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
                CenterCode = strCenterCode.ToInt(),
                PlaceSeqNo = strPlaceSeqNo.ToInt64(),
                SeqNos1    = strSeqNos1,
                SeqNos2    = strSeqNos2,
                SeqNos3    = strSeqNos3,
                SeqNos4    = strSeqNos4,
                SeqNos5    = strSeqNos5,
                GradeCode  = objSes.GradeCode,
                AdminID    = objSes.AdminID
            };
                
            lo_objResClientPlaceChargeIns = objClientPlaceChargeDasServices.DelCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode             = lo_objResClientPlaceChargeIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChargeUpdate()
    {
        ClientPlaceChargeViewModel lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>        lo_objResClientPlaceChargeIns = null;

        if (string.IsNullOrWhiteSpace(strPlaceSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeIns = new ClientPlaceChargeViewModel
            {
                PlaceSeqNo   = strPlaceSeqNo.ToInt64(),
                ClientCode   = strClientCode.ToInt(),
                PlacePost    = strPlacePost,
                PlaceAddr    = strPlaceAddr,
                PlaceAddrDtl = strPlaceAddrDtl,
                Sido         = strSido,
                Gugun        = strGugun,
                Dong         = strDong,
                FullAddr     = strSido + " " + strGugun + " " + strDong,
                LocalCode    = strLocalCode,
                LocalName    = strLocalName,
                PlaceRemark1 = strPlaceRemark1,
                PlaceRemark2 = strPlaceRemark2,
                PlaceRemark3 = strPlaceRemark3,
                PlaceRemark4 = strPlaceRemark4,
                UseFlag      = strUseFlag,
                AdminID      = objSes.AdminID
            };
                
            lo_objResClientPlaceChargeIns = objClientPlaceChargeDasServices.UpdCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode             = lo_objResClientPlaceChargeIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
            else
            { 
                objResMap.Add("PlaceSeqNo", strPlaceSeqNo.ToInt64());    
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientPlaceChargeHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        try
        {
            
            lo_objReqClientSearchList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                UseFlag          = "Y",
                ClientFlag       = "Y",
                ChargeFlag       = "N",
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

            SiteGlobal.WriteLog("ClientCsHandler", "Exception",
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