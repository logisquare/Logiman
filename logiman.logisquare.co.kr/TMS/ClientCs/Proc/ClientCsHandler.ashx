<%@ WebHandler Language="C#" Class="ClientCsHandler" %>
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
/// FileName        : ClientCsHandler.ashx
/// Description     : 담당 고객사 관리
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-02
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ClientCsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClientCs/ClientCsList"; //필수

    // 메소드 리스트
    private const string MethodClientCsList      = "ClientCsList";
    private const string MethodClientCsExcelList = "ClientCsExcelList";
    private const string MethodClientCsIns       = "ClientCsIns";
    private const string MethodClientCsDel       = "ClientCsDel";
    private const string MethodAdminUserList     = "AdminUserList";
    private const string MethodClientList        = "ClientList";
        
    ClientCsDasServices objClientCsDasServices = new ClientCsDasServices();
    ClientDasServices   objClientDasServices   = new ClientDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strCsSeqNo           = string.Empty;
    private string strCsSeqNos1         = string.Empty;
    private string strCsSeqNos2         = string.Empty;
    private string strCsSeqNos3         = string.Empty;
    private string strCsSeqNos4         = string.Empty;
    private string strCsSeqNos5         = string.Empty;
    private string strClientCode        = string.Empty;
    private string strClientName        = string.Empty;
    private string strCenterCode        = string.Empty;
    private string strOrderItemCode     = string.Empty;
    private string strOrderInoutCode    = string.Empty;
    private string strOrderLocationCode = string.Empty;
    private string strCsAdminType       = string.Empty;
    private string strCsAdminID         = string.Empty;
    private string strCsAdminName       = string.Empty;
    private string strDelFlag           = string.Empty;
    private string strAdminName         = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodClientCsList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientCsExcelList, MenuAuthType.All);
        objMethodAuthList.Add(MethodClientCsIns,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientCsDel,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminUserList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,        MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("ClientCsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ClientCsHandler");
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
            strCsSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("CsSeqNo"), "0");
            strCsSeqNos1         = SiteGlobal.GetRequestForm("CsSeqNos1");
            strCsSeqNos2         = SiteGlobal.GetRequestForm("CsSeqNos2");
            strCsSeqNos3         = SiteGlobal.GetRequestForm("CsSeqNos3");
            strCsSeqNos4         = SiteGlobal.GetRequestForm("CsSeqNos4");
            strCsSeqNos5         = SiteGlobal.GetRequestForm("CsSeqNos5");
            strClientCode        = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderItemCode     = SiteGlobal.GetRequestForm("OrderItemCode");
            strOrderInoutCode    = SiteGlobal.GetRequestForm("OrderInoutCode");
            strOrderLocationCode = SiteGlobal.GetRequestForm("OrderLocationCode");
            strCsAdminType       = Utils.IsNull(SiteGlobal.GetRequestForm("CsAdminType"), "0");
            strCsAdminID         = SiteGlobal.GetRequestForm("CsAdminID");
            strCsAdminName       = SiteGlobal.GetRequestForm("CsAdminName");
            strDelFlag           = SiteGlobal.GetRequestForm("DelFlag");
            strClientName        = SiteGlobal.GetRequestForm("ClientName");
            strAdminName         = SiteGlobal.GetRequestForm("AdminName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientCsHandler", "Exception",
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
                case MethodClientCsList:
                    GetClientCsList();
                    break;
                case MethodClientCsExcelList:
                    GetClientCsExcelList();
                    break;
                case MethodClientCsIns:
                    SetClientCsIns();
                    break;
                case MethodClientCsDel:
                    SetClientCsDel();
                    break;
                case MethodAdminUserList:
                    GetAdminUserList();
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

            SiteGlobal.WriteLog("ClientCsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 상하차지 + 담당자 목록
    /// </summary>
    protected void GetClientCsList()
    {
        ReqClientCsList                lo_objReqClientCsList = null;
        ServiceResult<ResClientCsList> lo_objResClientCsList = null;

        try
        {
            lo_objReqClientCsList = new ReqClientCsList
            {
                CsSeqNo           = strCsSeqNo.ToInt(),
                ClientCode        = strClientCode.ToInt(),
                CenterCode        = strCenterCode.ToInt(),
                OrderItemCode     = strOrderItemCode,
                OrderInoutCode    = strOrderInoutCode,
                OrderLocationCode = strOrderLocationCode,
                ClientName        = strClientName,
                CsAdminType       = strCsAdminType.ToInt(),
                CsAdminID         = strCsAdminID,
                CsAdminName       = strCsAdminName,
                DelFlag           = strDelFlag,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };
                
            lo_objResClientCsList = objClientCsDasServices.GetClientCsList(lo_objReqClientCsList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientCsList) + "]";
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

    /// <summary>
    /// 차량업체 엑셀 다운로드
    /// </summary>
    protected void GetClientCsExcelList()
    {
        ReqClientCsList                lo_objReqClientCsList = null;
        ServiceResult<ResClientCsList> lo_objResClientCsList = null;
        string                         lo_strFileName        = "";
        SpreadSheet                    lo_objExcel           = null;
        DataTable                      lo_dtData             = null;
        MemoryStream                   lo_outputStream       = null;
        byte[]                         lo_Content            = null;
        int                            lo_intColumnIndex     = 0;

        try
        {
            lo_objReqClientCsList = new ReqClientCsList
            {
                CsSeqNo           = strCsSeqNo.ToInt(),
                ClientCode        = strClientCode.ToInt(),
                CenterCode        = strCenterCode.ToInt(),
                OrderItemCode     = strOrderItemCode,
                OrderInoutCode    = strOrderInoutCode,
                OrderLocationCode = strOrderLocationCode,
                ClientName        = strClientName,
                CsAdminType       = strCsAdminType.ToInt(),
                CsAdminID         = strCsAdminID,
                CsAdminName       = strCsAdminName,
                DelFlag           = strDelFlag,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResClientCsList    = objClientCsDasServices.GetClientCsList(lo_objReqClientCsList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("담당구분",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("담당자명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("담당자아이디", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록일시",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록자",    typeof(string)));

            foreach (var row in lo_objResClientCsList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.ClientName, row.CsAdminTypeM, row.CsAdminName, row.CsAdminID
                    ,row.OrderItemCodeM, row.OrderLocationCodeM, row.RegDate, row.RegAdminID);
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

            SiteGlobal.WriteLog("ClientCsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetClientCsIns()
    {
        ClientCsViewModel                lo_objClientCs    = null;
        ServiceResult<ClientCsViewModel> lo_objResClientCs = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCsAdminType) || strCsAdminType.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[담당구분]";
            return;
        }

        if (strCsAdminType.Equals("1"))
        {

            if (string.IsNullOrWhiteSpace(strOrderItemCode))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.[상품]";
                return;
            }

            if (!strOrderItemCode.Equals("OA007"))
            {
                if (string.IsNullOrWhiteSpace(strOrderLocationCode))
                {
                    objResMap.RetCode = 9004;
                    objResMap.ErrMsg  = "필요한 값이 없습니다.[지역]";
                    return;
                }
            }
        }

        try
        {
            lo_objClientCs = new ClientCsViewModel
            {
                CenterCode        = strCenterCode.ToInt(),
                ClientCode        = strClientCode.ToInt(),
                CsAdminType       = strCsAdminType.ToInt(),
                CsAdminID         = strCsAdminID,
                CsAdminName       = strCsAdminName,
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                AdminID           = objSes.AdminID
            };
                
            lo_objResClientCs = objClientCsDasServices.InsClientCs(lo_objClientCs);
            objResMap.RetCode = lo_objResClientCs.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientCs.result.ErrorMsg;
                return;
            }

            objResMap.Add("CsSeqNo", lo_objResClientCs.data.CsSeqNo);
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

    protected void SetClientCsDel()
    {
        ClientCsViewModel                lo_objClientCs    = null;
        ServiceResult<ClientCsViewModel> lo_objResClientCs = null;

        if (string.IsNullOrWhiteSpace(strCsSeqNos1) && string.IsNullOrWhiteSpace(strCsSeqNos2) && string.IsNullOrWhiteSpace(strCsSeqNos3) && string.IsNullOrWhiteSpace(strCsSeqNos4) && string.IsNullOrWhiteSpace(strCsSeqNos5))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objClientCs = new ClientCsViewModel
            {
                CsSeqNos1 = strCsSeqNos1,
                CsSeqNos2 = strCsSeqNos2,
                CsSeqNos3 = strCsSeqNos3,
                CsSeqNos4 = strCsSeqNos4,
                CsSeqNos5 = strCsSeqNos5,
                AdminID   = objSes.AdminID
            };
                
            lo_objResClientCs = objClientCsDasServices.DelClientCs(lo_objClientCs);
            objResMap.RetCode = lo_objResClientCs.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientCs.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("CsSeqNo", strCsSeqNo);
            }
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

    //관리자 계정 출력 : 3:최고관리자, 4:담당 관리자, 5:담당자
    protected void GetAdminUserList()
    {
        ReqAdminList                lo_objReqAdminList = null;
        ServiceResult<ResAdminList> lo_objResAdminList = null;

        try
        {
            lo_objReqAdminList = new ReqAdminList
            {
                AdminName        = strAdminName,
                UseFlag          = "Y",
                AccessGradeCode  = "3,4,5",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResAdminList    = objClientCsDasServices.GetClientCsAdminList(lo_objReqAdminList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResAdminList) + "]";
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