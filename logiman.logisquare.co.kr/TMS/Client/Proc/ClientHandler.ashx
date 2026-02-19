<%@ WebHandler Language="C#" Class="ClientHandler" %>
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
/// FileName        : ClientHandler.ashx
/// Description     : 고객사 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemClientHandler
/// Author          : sybyun96@logislab.com, 2022-07-12
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ClientHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Client/ClientList"; //필수

    // 메소드 리스트
    private const string MethodClientList            = "ClientList";
    private const string MethodClientListExcel       = "ClientListExcel";
    private const string MethodClientIns             = "ClientInsert";
    private const string MethodClientUpd             = "ClientUpdate";
    private const string MethodClientCorpNoChk       = "ClientCorpNoChk";
    private const string MethodClientGetAcctRealName = "ClientGetAcctRealName";
    private const string MethodClientCenterTransList = "ClientCenterTransList";
    private const string MethodClientChargeList      = "ClientChargeList";
    private const string MethodClientChargeIns       = "ClientChargeInsert";
    private const string MethodClientChargeUpd       = "ClientChargeUpdate";
    private const string MethodClientChargeDel       = "ClientChargeDelete";
    ClientDasServices    objClientDasServices        = new ClientDasServices();
    CenterDasServices    objCenterDasServices        = new CenterDasServices();
    private HttpContext  objHttpContext              = null;

    private string strCallType             = string.Empty;
    private int    intPageSize             = 0;
    private int    intPageNo               = 0;
    private string strClientCode           = string.Empty;
    private string strCenterCode           = string.Empty;
    private string strClientType           = string.Empty;
    private string strClientName           = string.Empty;
    private string strClientCeoName        = string.Empty;
    private string strClientCorpNo         = string.Empty;
    private string strClientBizType        = string.Empty;
    private string strClientBizClass       = string.Empty;
    private string strClientTelNo          = string.Empty;
    private string strClientFaxNo          = string.Empty;
    private string strClientEmail          = string.Empty;
    private string strClientPost           = string.Empty;
    private string strClientAddr           = string.Empty;
    private string strClientAddrDtl        = string.Empty;
    private string strClientStatus         = string.Empty;
    private string strClientCloseYMD       = string.Empty;
    private string strClientUpdYMD         = string.Empty;
    private string strClientTaxKind        = string.Empty;
    private string strClientTaxMsg         = string.Empty;
    private string strClientClosingType    = string.Empty;
    private string strClientPayDay         = string.Empty;
    private string strClientBusinessStatus = string.Empty;
    private string strClientDMPost         = string.Empty;
    private string strClientDMAddr         = string.Empty;
    private string strClientDMAddrDtl      = string.Empty;
    private string strClientFPISFlag       = string.Empty;
    private string strClientBankCode       = string.Empty;
    private string strClientAcctNo         = string.Empty;
    private string strClientAcctName       = string.Empty;
    private string strClientNote1          = string.Empty;
    private string strClientNote2          = string.Empty;
    private string strClientNote3          = string.Empty;
    private string strClientNote4          = string.Empty;
    private string strSaleLimitAmt         = string.Empty;
    private string strRevenueLimitPer      = string.Empty;
    private string strUseFlag              = string.Empty;
    private string strClientEncAcctNo      = string.Empty;
    private string strClientSearchAcctNo   = string.Empty;
    private string strClientCheckYMD       = string.Empty;
    private string strTransCenterCode      = string.Empty;
    private string strDouzoneCode          = string.Empty;
    private string strChargeSeqNo          = string.Empty;
    private string strChargeName           = string.Empty;
    private string strChargeCell           = string.Empty;
    private string strChargeTelNo          = string.Empty;
    private string strChargeTelExtNo       = string.Empty;
    private string strChargeFaxNo          = string.Empty;
    private string strChargeEmail          = string.Empty;
    private string strChargePosition       = string.Empty;
    private string strChargeDepartment     = string.Empty;
    private string strChargeLocation       = string.Empty;
    private string strChargeOrderFlag      = string.Empty;
    private string strChargePayFlag        = string.Empty;
    private string strChargeArrivalFlag    = string.Empty;
    private string strChargeBillFlag       = string.Empty;
    private string strChargeUseFlag        = string.Empty;
    private string strSaleLimitAmtFlag     = string.Empty;
    private string strRevenueLimitPerFlag  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodClientList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientListExcel,       MenuAuthType.All);
        objMethodAuthList.Add(MethodClientIns,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientUpd,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientCorpNoChk,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientGetAcctRealName, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientCenterTransList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeIns,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientChargeUpd,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientChargeDel,       MenuAuthType.ReadWrite);
        
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

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ClientHandler");
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
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strClientType           = SiteGlobal.GetRequestForm("ClientType");
            strClientName           = SiteGlobal.GetRequestForm("ClientName");
            strClientCeoName        = SiteGlobal.GetRequestForm("ClientCeoName");
            strClientCorpNo         = SiteGlobal.GetRequestForm("ClientCorpNo");
            strClientBizType        = SiteGlobal.GetRequestForm("ClientBizType");
            strClientBizClass       = SiteGlobal.GetRequestForm("ClientBizClass");
            strClientTelNo          = SiteGlobal.GetRequestForm("ClientTelNo");
            strClientFaxNo          = SiteGlobal.GetRequestForm("ClientFaxNo");
            strClientEmail          = SiteGlobal.GetRequestForm("ClientEmail");
            strClientPost           = SiteGlobal.GetRequestForm("ClientPost");
            strClientAddr           = SiteGlobal.GetRequestForm("ClientAddr");
            strClientAddrDtl        = SiteGlobal.GetRequestForm("ClientAddrDtl");
            strClientStatus         = Utils.IsNull(SiteGlobal.GetRequestForm("ClientStatus"), "1");
            strClientCloseYMD       = SiteGlobal.GetRequestForm("ClientCloseYMD");
            strClientUpdYMD         = SiteGlobal.GetRequestForm("ClientUpdYMD");
            strClientTaxKind        = Utils.IsNull(SiteGlobal.GetRequestForm("ClientTaxKind"), "1");
            strClientTaxMsg         = SiteGlobal.GetRequestForm("ClientTaxMsg");
            strClientClosingType    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientClosingType"), "0");
            strClientPayDay         = SiteGlobal.GetRequestForm("ClientPayDay");
            strClientBusinessStatus = Utils.IsNull(SiteGlobal.GetRequestForm("ClientBusinessStatus"), "1");
            strClientDMPost         = SiteGlobal.GetRequestForm("ClientDMPost");
            strClientDMAddr         = SiteGlobal.GetRequestForm("ClientDMAddr");
            strClientDMAddrDtl      = SiteGlobal.GetRequestForm("ClientDMAddrDtl");
            strClientFPISFlag       = SiteGlobal.GetRequestForm("ClientFPISFlag");
            strClientBankCode       = SiteGlobal.GetRequestForm("ClientBankCode");
            strClientAcctNo         = SiteGlobal.GetRequestForm("ClientAcctNo");
            strClientAcctName       = SiteGlobal.GetRequestForm("ClientAcctName");
            strClientNote1          = SiteGlobal.GetRequestForm("ClientNote1");
            strClientNote2          = SiteGlobal.GetRequestForm("ClientNote2");
            strClientNote3          = SiteGlobal.GetRequestForm("ClientNote3");
            strClientNote4          = SiteGlobal.GetRequestForm("ClientNote4");
            strSaleLimitAmt         = Utils.IsNull(SiteGlobal.GetRequestForm("SaleLimitAmt"), "0");
            strRevenueLimitPer      = Utils.IsNull(SiteGlobal.GetRequestForm("RevenueLimitPer"), "0");
            strUseFlag              = SiteGlobal.GetRequestForm("UseFlag");
            strTransCenterCode      = Utils.IsNull(SiteGlobal.GetRequestForm("TransCenterCode"), "0");
            strDouzoneCode          = SiteGlobal.GetRequestForm("DouzoneCode");
            strChargeSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeSeqNo"), "0");
            strChargeName           = SiteGlobal.GetRequestForm("ChargeName");
            strChargeCell           = SiteGlobal.GetRequestForm("ChargeCell");
            strChargeTelNo          = SiteGlobal.GetRequestForm("ChargeTelNo");
            strChargeTelExtNo       = SiteGlobal.GetRequestForm("ChargeTelExtNo");
            strChargeFaxNo          = SiteGlobal.GetRequestForm("ChargeFaxNo");
            strChargeEmail          = SiteGlobal.GetRequestForm("ChargeEmail");
            strChargePosition       = SiteGlobal.GetRequestForm("ChargePosition");
            strChargeDepartment     = SiteGlobal.GetRequestForm("ChargeDepartment");
            strChargeLocation       = SiteGlobal.GetRequestForm("ChargeLocation");
            strChargeOrderFlag      = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag        = SiteGlobal.GetRequestForm("ChargePayFlag");
            strChargeArrivalFlag    = SiteGlobal.GetRequestForm("ChargeArrivalFlag");
            strChargeBillFlag       = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strChargeUseFlag        = SiteGlobal.GetRequestForm("ChargeUseFlag");
            strSaleLimitAmtFlag     = SiteGlobal.GetRequestForm("SaleLimitAmtFlag");
            strRevenueLimitPerFlag  = SiteGlobal.GetRequestForm("RevenueLimitPerFlag");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
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
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientListExcel:
                    GetClientListExcel();
                    break;
                case MethodClientIns:
                    SetClientIns();
                    break;
                case MethodClientUpd:
                    SetClientUpd();
                    break;
                case MethodClientCorpNoChk:
                    GetClientCorpNoChk();
                    break;
                case MethodClientGetAcctRealName:
                    GetClientGetAcctRealName();
                    break;
                case MethodClientCenterTransList:
                    GetClientCenterTransList();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodClientChargeIns:
                    SetClientChargeIns();
                    break;
                case MethodClientChargeUpd:
                    SetClientChargeUpd();
                    break;
                case MethodClientChargeDel:
                    SetClientChargeDel();
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

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
        
    
    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                ClientCode          = strClientCode.ToInt(),
                CenterCode          = strCenterCode.ToInt(),
                ClientType          = strClientType,
                ClientName          = strClientName,
                ClientCeoName       = strClientCeoName,
                ClientCorpNo        = strClientCorpNo,
                SaleLimitAmtFlag    = strSaleLimitAmtFlag,
                RevenueLimitPerFlag = strRevenueLimitPerFlag,
                UseFlag             = strUseFlag,
                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 엑셀 다운로드
    /// </summary>
    protected void GetClientListExcel()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                ClientCode          = strClientCode.ToInt(),
                CenterCode          = strCenterCode.ToInt(),
                ClientType          = strClientType,
                ClientName          = strClientName,
                ClientCeoName       = strClientCeoName,
                ClientCorpNo        = strClientCorpNo,
                SaleLimitAmtFlag    = strSaleLimitAmtFlag,
                RevenueLimitPerFlag = strRevenueLimitPerFlag,
                UseFlag             = strUseFlag,
                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo
            };

            lo_objResClientList = objClientDasServices.GetClientList(lo_objReqClientList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객사구분", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("거래상태",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출여신일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("대표자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("팩스",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("종목",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업태",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용여부",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자체크",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물실적신고대상", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록자",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정자",      typeof(string)));

            foreach (var row in lo_objResClientList.data.list)
            {

                lo_dtData.Rows.Add(row.CenterName, row.ClientTypeM, row.ClientBusinessStatusM, row.ClientPayDayM, row.ClientCorpNo
                    , row.ClientName, row.ClientCeoName,row.ClientAddr, row.ClientTelNo, row.ClientFaxNo
                    , row.ClientBizType, row.ClientBizClass,row.UseFlag, row.ClientStatusM, row.ClientFPISFlag
                    , row.RegDate, row.RegAdminID,  row.UpdDate, row.UpdAdminID);

            }

            lo_objExcel = new SpreadSheet {SheetName = "ClientList"};

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

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 등록
    /// </summary>
    protected void SetClientIns()
    {

        ClientModel                      lo_objClientModel        = null;
        ServiceResult<ClientModel>       lo_objResClientIns       = null;
        ClientChargeModel                lo_objClientChargeModel  = null;
        ServiceResult<ClientChargeModel> lo_objResClientChargeIns = null;
        int                              lo_intClientCode         = 0;
            
        strClientFPISFlag    = Utils.IsNull(strClientFPISFlag,    "N");
        strChargeOrderFlag   = Utils.IsNull(strChargeOrderFlag,   "N");
        strChargePayFlag     = Utils.IsNull(strChargePayFlag,     "N");
        strChargeArrivalFlag = Utils.IsNull(strChargeArrivalFlag, "N");
        strChargeBillFlag    = Utils.IsNull(strChargeBillFlag,    "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientName) || string.IsNullOrWhiteSpace(strClientCorpNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientAcctNo) || string.IsNullOrWhiteSpace(strClientBankCode) || string.IsNullOrWhiteSpace(strClientAcctName))
        {
            strClientAcctNo   = string.Empty;
            strClientBankCode = string.Empty;
            strClientAcctName = string.Empty;
        }

        if (!string.IsNullOrWhiteSpace(strClientAcctNo))
        {
            strClientSearchAcctNo = strClientAcctNo.Right(4);
            strClientEncAcctNo    = Utils.GetEncrypt(strClientAcctNo, SiteGlobal.AES2_ENC_IV_VALUE);
        }

        try
        {
            lo_objClientModel = new ClientModel
            {
                CenterCode           = strCenterCode.ToInt(),
                ClientType           = strClientType,
                ClientName           = strClientName,
                ClientCeoName        = strClientCeoName,
                ClientCorpNo         = strClientCorpNo,
                ClientBizType        = strClientBizType,
                ClientBizClass       = strClientBizClass,
                ClientTelNo          = strClientTelNo,
                ClientFaxNo          = strClientFaxNo,
                ClientEmail          = strClientEmail,
                ClientPost           = strClientPost,
                ClientAddr           = strClientAddr,
                ClientAddrDtl        = strClientAddrDtl,
                ClientStatus         = strClientStatus.ToInt(),
                ClientCloseYMD       = strClientCloseYMD,
                ClientUpdYMD         = strClientUpdYMD,
                ClientTaxKind        = strClientTaxKind.ToInt(),
                ClientTaxMsg         = strClientTaxMsg,
                ClientCheckYMD       = strClientCheckYMD,
                ClientClosingType    = strClientClosingType.ToInt(),
                ClientPayDay         = strClientPayDay,
                ClientBusinessStatus = strClientBusinessStatus.ToInt(),
                ClientDMPost         = strClientDMPost,
                ClientDMAddr         = strClientDMAddr,
                ClientDMAddrDtl      = strClientDMAddrDtl,
                ClientFPISFlag       = strClientFPISFlag,
                ClientBankCode       = strClientBankCode,
                ClientEncAcctNo      = strClientEncAcctNo,
                ClientSearchAcctNo   = strClientSearchAcctNo,
                ClientAcctName       = strClientAcctName,
                TransCenterCode      = strTransCenterCode.ToInt(),
                ClientNote1          = strClientNote1,
                ClientNote2          = strClientNote2,
                ClientNote3          = strClientNote3,
                ClientNote4          = strClientNote4,
                SaleLimitAmt         = strSaleLimitAmt.ToDouble(),
                RevenueLimitPer      = strRevenueLimitPer.ToDouble(),
                DouzoneCode          = strDouzoneCode,
                RegAdminID           = objSes.AdminID
            };

            lo_objResClientIns = objClientDasServices.SetClientIns(lo_objClientModel);
            objResMap.RetCode  = lo_objResClientIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientIns.result.ErrorMsg;
            }
            else
            {
                lo_intClientCode = lo_objResClientIns.data.ClientCode;
                objResMap.Add("ClientCode", lo_intClientCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (lo_intClientCode.Equals(0) || string.IsNullOrWhiteSpace(strChargeName) || (string.IsNullOrWhiteSpace(strChargeCell) && string.IsNullOrWhiteSpace(strChargeTelNo)))
        {
            return;
        }

        if (strChargeOrderFlag.Equals("N") && strChargePayFlag.Equals("N")  && strChargeArrivalFlag.Equals("N")  && strChargeBillFlag.Equals("N"))
        {
            return;
        }

        //담당자정보가 있으면 함께 등록
        try
        {
            lo_objClientChargeModel = new ClientChargeModel
            {
                CenterCode           = strCenterCode.ToInt(),
                ClientCode           = lo_intClientCode,
                OrderFlag            = strChargeOrderFlag,
                PayFlag              = strChargePayFlag,
                ArrivalFlag          = strChargeArrivalFlag,
                BillFlag             = strChargeBillFlag,
                ChargeName           = strChargeName,
                ChargeLocation       = strChargeLocation,
                ChargeTelExtNo       = strChargeTelExtNo,
                ChargeTelNo          = strChargeTelNo,
                ChargeCell           = strChargeCell,
                ChargeFaxNo          = strChargeFaxNo,
                ChargeEmail          = strChargeEmail,
                ChargePosition       = strChargePosition,
                ChargeDepartment     = strChargeDepartment,
                UseFlag              = strChargeUseFlag,
                RegAdminID           = objSes.AdminID
            };

            lo_objResClientChargeIns = objClientDasServices.SetClientChargeIns(lo_objClientChargeModel);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
        
    }

    /// <summary>
    /// 고객사 수정
    /// </summary>
    protected void SetClientUpd()
    {

        ClientModel         lo_objClientModel  = null;
        ServiceResult<bool> lo_objResClientUpd = null;

        strUseFlag        = Utils.IsNull(strUseFlag,        "N");
        strClientFPISFlag = Utils.IsNull(strClientFPISFlag, "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strClientName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientAcctNo) || string.IsNullOrWhiteSpace(strClientBankCode) || string.IsNullOrWhiteSpace(strClientAcctName))
        {
            strClientAcctNo   = string.Empty;
            strClientBankCode = string.Empty;
            strClientAcctName = string.Empty;
        }

        if (!string.IsNullOrWhiteSpace(strClientAcctNo))
        {
            strClientSearchAcctNo = strClientAcctNo.Right(4);
            strClientEncAcctNo    = Utils.GetEncrypt(strClientAcctNo, SiteGlobal.AES2_ENC_IV_VALUE);
        }

        try
        {
            lo_objClientModel = new ClientModel
            {
                ClientCode           = strClientCode.ToInt(),
                CenterCode           = strCenterCode.ToInt(),
                ClientType           = strClientType,
                ClientName           = strClientName,
                ClientCeoName        = strClientCeoName,
                ClientBizType        = strClientBizType,
                ClientBizClass       = strClientBizClass,
                ClientTelNo          = strClientTelNo,
                ClientFaxNo          = strClientFaxNo,
                ClientEmail          = strClientEmail,
                ClientPost           = strClientPost,
                ClientAddr           = strClientAddr,
                ClientAddrDtl        = strClientAddrDtl,
                ClientClosingType    = strClientClosingType.ToInt(),
                ClientPayDay         = strClientPayDay,
                ClientBusinessStatus = strClientBusinessStatus.ToInt(),
                ClientDMPost         = strClientDMPost,
                ClientDMAddr         = strClientDMAddr,
                ClientDMAddrDtl      = strClientDMAddrDtl,
                ClientFPISFlag       = strClientFPISFlag,
                ClientBankCode       = strClientBankCode,
                ClientEncAcctNo      = strClientEncAcctNo,
                ClientSearchAcctNo   = strClientSearchAcctNo,
                ClientAcctName       = strClientAcctName,
                TransCenterCode      = strTransCenterCode.ToInt(),
                ClientNote1          = strClientNote1,
                ClientNote2          = strClientNote2,
                ClientNote3          = strClientNote3,
                ClientNote4          = strClientNote4,
                SaleLimitAmt         = strSaleLimitAmt.ToDouble(),
                RevenueLimitPer      = strRevenueLimitPer.ToDouble(),
                DouzoneCode          = strDouzoneCode,
                UseFlag              = strUseFlag,
                UpdAdminID           = objSes.AdminID
            };

            lo_objResClientUpd = objClientDasServices.SetClientUpd(lo_objClientModel);
            objResMap.RetCode  = lo_objResClientUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ClientCode", strClientCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 사업자 중복 체크
    /// </summary>
    protected void GetClientCorpNoChk()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;
        ReqChkCorpNo                 lo_objReqChkCorpNo  = null;
        ResChkCorpNo                 lo_objResChkCorpNo  = null;
        int                          lo_intClientTaxKind = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCorpNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        // 중복 사업자 체크
        try
        {
            lo_objReqClientList = new ReqClientList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCorpNo     = strClientCorpNo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);

            if (lo_objResClientList.data.RecordCnt > 0)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "이미 등록된 사업자입니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }

        try
        {
            lo_objReqChkCorpNo = new ReqChkCorpNo
            {
                CorpNo = strClientCorpNo
            };

            lo_objResChkCorpNo = SiteGlobal.ChkCorpNo(lo_objReqChkCorpNo);

            if (lo_objResChkCorpNo.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "사업자 휴폐업 조회에 실패했습니다.";
                return;
            }

            lo_intClientTaxKind = lo_objResChkCorpNo.Payload.CorpCode > 1 ? lo_objResChkCorpNo.Payload.CorpCode : 1;
            objResMap.Add("ClientStatus",   lo_objResChkCorpNo.Payload.ServiceCode);
            objResMap.Add("ClientCorpNo",   lo_objResChkCorpNo.Payload.CorpNo);
            objResMap.Add("ClientCloseYMD", lo_objResChkCorpNo.Payload.CloseDate);
            objResMap.Add("ClientUpdYMD",   lo_objResChkCorpNo.Payload.ChangeDate);
            objResMap.Add("ClientTaxKind",  lo_intClientTaxKind);
            objResMap.Add("ClientTaxMsg",   lo_objResChkCorpNo.Payload.CorpCodeMsg);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 예금주명 조회
    /// </summary>
    protected void GetClientGetAcctRealName()
    {
        ReqGetAcctRealName lo_objReqGetAcctRealName = null;
        ResGetAcctRealName lo_objResGetAcctRealName = null;

        if (string.IsNullOrWhiteSpace(strClientAcctNo) || string.IsNullOrWhiteSpace(strClientBankCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //얘금주명 조회
        try
        {
            lo_objReqGetAcctRealName = new ReqGetAcctRealName
            {
                CorpNo   = strClientCorpNo,
                AcctNo   = strClientAcctNo,
                BankCode = strClientBankCode
            };

            lo_objResGetAcctRealName = SiteGlobal.GetAcctRealName(lo_objReqGetAcctRealName);

            if (lo_objResGetAcctRealName.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "예금주명 조회에 실패했습니다.";
                return;
            }

            objResMap.Add("ClientBankCode",   lo_objResGetAcctRealName.Payload.BankCode);
            objResMap.Add("ClientAcctNo",     lo_objResGetAcctRealName.Payload.AcctNo);
            objResMap.Add("ClientAcctName",   lo_objResGetAcctRealName.Payload.AcctName);
            objResMap.Add("ExistsFlag",       lo_objResGetAcctRealName.Payload.ExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계열사 목록
    /// </summary>
    protected void GetClientCenterTransList()
    {
        ReqCenterList                         lo_objReqCenterList          = null;
        ServiceResult<ResCenterList>          lo_objResCenterList          = null;
        ReqCenterFranchiseList                lo_objReqCenterFranchiseList = null;
        ServiceResult<ResCenterFranchiseList> lo_objResCenterFranchiseList = null;
        int                                   lo_intCenterType             = 0;

        try
        {
            lo_objReqCenterList = new ReqCenterList
            {
                AdminID    = objSes.AdminID,
                CenterCode = strCenterCode.ToInt(),
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCenterList = objCenterDasServices.GetCenterList(lo_objReqCenterList);
            if (!lo_objResCenterList.data.RecordCnt.Equals(1))
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                return;
            }

            lo_intCenterType = lo_objResCenterList.data.list[0].CenterType;
            objResMap.Add("CenterType", lo_intCenterType);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //본부일때
        if (lo_intCenterType.Equals(1))
        {
            try
            {
                lo_objReqCenterFranchiseList = new ReqCenterFranchiseList
                {
                    HeadCenterCode  = strCenterCode.ToInt(),
                    AddHeadFlag     = "N",
                    AddBranchFlag   = "Y",
                    AddContractFlag = "N"
                };

                lo_objResCenterFranchiseList = objCenterDasServices.GetCenterFranchiseList(lo_objReqCenterFranchiseList);
                if (lo_objResCenterFranchiseList.data.RecordCnt > 0)
                {
                    
                    objResMap.Add("RecordCnt", lo_objResCenterFranchiseList.data.RecordCnt);
                    objResMap.Add("List",      lo_objResCenterFranchiseList.data.list);
                }
                else
                {
                    objResMap.Add("RecordCnt", 0);
                    objResMap.Add("List",      null);
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("ClientHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
    }

    /// <summary>
    /// 고객사 담당자 목록
    /// </summary>
    protected void GetClientChargeList()
    {
        ReqClientChargeList                lo_objReqClientChargeList = null;
        ServiceResult<ResClientChargeList> lo_objResClientChargeList = null;

        try
        {
            lo_objReqClientChargeList = new ReqClientChargeList
            {
                ClientCode       = strClientCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                OrderFlag        = strChargeOrderFlag,
                PayFlag          = strChargePayFlag,
                ArrivalFlag      = strChargeArrivalFlag,
                BillFlag         = strChargeBillFlag,
                ChargeName       = strChargeName,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientChargeList   = objClientDasServices.GetClientChargeList(lo_objReqClientChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientChargeHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 담당자 등록
    /// </summary>
    protected void SetClientChargeIns()
    {
        ClientChargeModel                lo_objClientChargeModel  = null;
        ServiceResult<ClientChargeModel> lo_objResClientChargeIns = null;
            
        strChargeOrderFlag   = Utils.IsNull(strChargeOrderFlag,   "N");
        strChargePayFlag     = Utils.IsNull(strChargePayFlag,     "N");
        strChargeArrivalFlag = Utils.IsNull(strChargeArrivalFlag, "N");
        strChargeBillFlag    = Utils.IsNull(strChargeBillFlag,    "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strChargeName) || (string.IsNullOrWhiteSpace(strChargeTelNo) && string.IsNullOrWhiteSpace(strChargeCell)))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strChargeOrderFlag.Equals("N") && strChargePayFlag.Equals("N") && strChargeArrivalFlag.Equals("N") && strChargeBillFlag.Equals("N"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objClientChargeModel = new ClientChargeModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ChargeName       = strChargeName,
                ChargeLocation   = strChargeLocation,
                ChargeTelExtNo   = strChargeTelExtNo,
                ChargeTelNo      = strChargeTelNo,
                ChargeCell       = strChargeCell,
                ChargeFaxNo      = strChargeFaxNo,
                ChargeEmail      = strChargeEmail,
                ChargePosition   = strChargePosition,
                ChargeDepartment = strChargeDepartment,
                OrderFlag        = strChargeOrderFlag,
                PayFlag          = strChargePayFlag,
                ArrivalFlag      = strChargeArrivalFlag,
                BillFlag         = strChargeBillFlag,
                UseFlag          = strChargeUseFlag,
                RegAdminID       = objSes.AdminID
            };

            lo_objResClientChargeIns = objClientDasServices.SetClientChargeIns(lo_objClientChargeModel);

            objResMap.RetCode = lo_objResClientChargeIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientChargeIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ChargeSeqNo", lo_objResClientChargeIns.data.ChargeSeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 담당자 수정
    /// </summary>
    protected void SetClientChargeUpd()
    {
        ClientChargeModel   lo_objClientChargeModel  = null;
        ServiceResult<bool> lo_objResClientChargeUpd = null;
            
        strChargeOrderFlag   = Utils.IsNull(strChargeOrderFlag,   "N");
        strChargePayFlag     = Utils.IsNull(strChargePayFlag,     "N");
        strChargeArrivalFlag = Utils.IsNull(strChargeArrivalFlag, "N");
        strChargeBillFlag    = Utils.IsNull(strChargeBillFlag,    "N");

        if (string.IsNullOrWhiteSpace(strChargeSeqNo) || strChargeSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strChargeName) || (string.IsNullOrWhiteSpace(strChargeTelNo) && string.IsNullOrWhiteSpace(strChargeCell)))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strChargeOrderFlag.Equals("N") && strChargePayFlag.Equals("N") && strChargeArrivalFlag.Equals("N") && strChargeBillFlag.Equals("N"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objClientChargeModel = new ClientChargeModel
            {
                ChargeSeqNo      = strChargeSeqNo.ToInt(),
                ChargeName       = strChargeName,
                ChargeLocation   = strChargeLocation,
                ChargeTelExtNo   = strChargeTelExtNo,
                ChargeTelNo      = strChargeTelNo,
                ChargeCell       = strChargeCell,
                ChargeFaxNo      = strChargeFaxNo,
                ChargeEmail      = strChargeEmail,
                ChargePosition   = strChargePosition,
                ChargeDepartment = strChargeDepartment,
                OrderFlag        = strChargeOrderFlag,
                PayFlag          = strChargePayFlag,
                ArrivalFlag      = strChargeArrivalFlag,
                BillFlag         = strChargeBillFlag,
                UseFlag          = strChargeUseFlag,
                UpdAdminID       = objSes.AdminID
            };

            lo_objResClientChargeUpd = objClientDasServices.SetClientChargeUpd(lo_objClientChargeModel);

            objResMap.RetCode = lo_objResClientChargeUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientChargeUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 담당자 삭제
    /// </summary>
    protected void SetClientChargeDel()
    {
        ServiceResult<bool> lo_objResClientChargeDel = null;

        if (string.IsNullOrWhiteSpace(strChargeSeqNo) || strChargeSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objResClientChargeDel = objClientDasServices.SetClientChargeDel(strChargeSeqNo.ToInt());

            objResMap.RetCode = lo_objResClientChargeDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientChargeDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
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