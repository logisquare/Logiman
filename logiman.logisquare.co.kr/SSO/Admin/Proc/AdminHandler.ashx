<%@ WebHandler Language="C#" Class="AdminHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using DocumentFormat.OpenXml.Spreadsheet;

///================================================================
/// <summary>
/// FileName        : AdminHandler.ashx
/// Description     : 어드민 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : shadow54@logislab.com, 2022-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdminHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Admin/AdminList"; //필수

    // 메소드 리스트
    private const string MethodAdminList       = "AdminList";
    private const string MethodAdminListExcel  = "AdminListExcel";
    private const string MethodAdminInsert     = "AdminInsert";
    private const string MethodAdminUpdate     = "AdminUpdate";
    private const string MethodAdminLoginReset = "AdminLoginReset";
    private const string MethodAdminSendPwd    = "AdminSendPwd";
    private const string MethodClientList      = "ClientList";

    AdminDasServices  objAdminDasServices  = new AdminDasServices();
    ClientDasServices objClientDasServices = new ClientDasServices();

    private string strCallType         = string.Empty;
    private int    intPageSize         = 0;
    private int    intPageNo           = 0;
    private int    intGradeCode        = 0;
    private string strUseFlag          = string.Empty;
    private string strDupLoginFlag     = string.Empty;
    private string strMyOrderFlag      = string.Empty;
    private string strSearchType       = string.Empty;
    private string strListSearch       = string.Empty;
    private string strAdminID          = string.Empty;
    private string strAdminPwd         = string.Empty;
    private string strMobileNo         = string.Empty;
    private string strAdminName        = string.Empty;
    private string strAdminCorpNo      = string.Empty;
    private string strAdminCorpName    = string.Empty;
    private string strDeptName         = string.Empty;
    private string strTelNo            = string.Empty;
    private string strEmail            = string.Empty;
    private string strAccessIPChkFlag  = string.Empty;
    private string strAccessIP1        = string.Empty;
    private string strAccessIP2        = string.Empty;
    private string strAccessIP3        = string.Empty;
    private string strLastLoginDate    = string.Empty;
    private string strLastLoginIP      = string.Empty;
    private string strJoinYMD          = string.Empty;
    private string strExpireYMD        = string.Empty;
    private string strPwdUpdDate       = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strAccessCenterCode = string.Empty;
    private string strAccessCorpNo     = string.Empty;
    private string strNetwork24DDID    = string.Empty;
    private string strNetworkHMMID     = string.Empty;
    private string strNetworkOneCallID = string.Empty;
    private string strNetworkHmadangID = string.Empty;
    private string strAdminResetPwd    = string.Empty;
    private string strAdminPosition    = string.Empty;
    private string strPrivateAvailFlag = string.Empty;
    private string strClientName       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdminList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdminListExcel,  MenuAuthType.All);
        objMethodAuthList.Add(MethodAdminInsert,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminUpdate,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminLoginReset, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminSendPwd,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,      MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"), "0").ToInt();

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

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdminHandler");
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
            // Admin List
            intGradeCode        = Utils.IsNull(SiteGlobal.GetRequestForm("GradeCode"), "0").ToInt();
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strUseFlag          = SiteGlobal.GetRequestForm("UseFlag");
            strDupLoginFlag     = SiteGlobal.GetRequestForm("DupLoginFlag");
            strMyOrderFlag      = SiteGlobal.GetRequestForm("MyOrderFlag");
            strSearchType       = SiteGlobal.GetRequestForm("SearchType");
            strListSearch       = SiteGlobal.GetRequestForm("ListSearch");
            strAdminID          = SiteGlobal.GetRequestForm("AdminID");
            strAdminPwd         = SiteGlobal.GetRequestForm("AdminPwd");
            strMobileNo         = SiteGlobal.GetRequestForm("MobileNo");
            strAdminName        = SiteGlobal.GetRequestForm("AdminName");
            strAdminCorpNo      = SiteGlobal.GetRequestForm("AdminCorpNo");
            strAdminCorpName    = SiteGlobal.GetRequestForm("AdminCorpName");
            strDeptName         = SiteGlobal.GetRequestForm("DeptName");
            strTelNo            = SiteGlobal.GetRequestForm("TelNo");
            strEmail            = SiteGlobal.GetRequestForm("Email");
            strAccessIPChkFlag  = SiteGlobal.GetRequestForm("AccessIPChkFlag");
            strAccessIP1        = SiteGlobal.GetRequestForm("AccessIP1");
            strAccessIP2        = SiteGlobal.GetRequestForm("AccessIP2");
            strAccessIP3        = SiteGlobal.GetRequestForm("AccessIP3");
            strLastLoginDate    = SiteGlobal.GetRequestForm("LastLoginDate");
            strLastLoginIP      = SiteGlobal.GetRequestForm("LastLoginIP");
            strJoinYMD          = SiteGlobal.GetRequestForm("JoinYMD");
            strExpireYMD        = SiteGlobal.GetRequestForm("ExpireYMD");
            strPwdUpdDate       = SiteGlobal.GetRequestForm("PwdUpdDate");
            strAccessCenterCode = SiteGlobal.GetRequestForm("AccessCenterCode");
            strAccessCorpNo     = SiteGlobal.GetRequestForm("AccessCorpNo");
            strNetwork24DDID    = SiteGlobal.GetRequestForm("Network24DDID");
            strNetworkHMMID     = SiteGlobal.GetRequestForm("NetworkHMMID");
            strNetworkOneCallID = SiteGlobal.GetRequestForm("NetworkOneCallID");
            strNetworkHmadangID = SiteGlobal.GetRequestForm("NetworkHmadangID");
            strAdminResetPwd    = SiteGlobal.GetRequestForm("AdminResetPwd");
            strAdminPosition    = SiteGlobal.GetRequestForm("AdminPosition");
            strPrivateAvailFlag = Utils.IsNull(SiteGlobal.GetRequestForm("PrivateAvailFlag"), "N");
            strClientName       = SiteGlobal.GetRequestForm("ClientName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
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
                case MethodAdminList:
                    GetAdminList();
                    break;
                case MethodAdminListExcel:
                    GetAdminListExcel();
                    break;
                case MethodAdminInsert:
                    InsAdmin();
                    break;
                case MethodAdminUpdate:
                    UpdAdmin();
                    break;
                case MethodAdminLoginReset:
                    ResetLoginAdmin();
                    break;
                case MethodAdminSendPwd:
                    SendPwdAdmin();
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

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void GetAdminList()
    {
        string                      lo_strAdminID      = string.Empty;
        string                      lo_strAdminName    = string.Empty;
        string                      lo_strMobileNo     = string.Empty;
        ReqAdminList                lo_objReqAdminList = null;
        ServiceResult<ResAdminList> lo_objResAdminList = null;

        try
        {
            switch (strSearchType)
            {
                case "AdminID":
                    lo_strAdminID = strListSearch;
                    break;
                case "AdminName":
                    lo_strAdminName = strListSearch;
                    break;
                case "MobileNo":
                    lo_strMobileNo = strListSearch;
                    break;
            }

            lo_objReqAdminList = new ReqAdminList
            {
                AdminID          = lo_strAdminID,
                MobileNo         = lo_strMobileNo,
                AdminName        = lo_strAdminName,
                GradeCode        = intGradeCode,
                UseFlag          = strUseFlag,
                SesGradeCode     = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResAdminList    = objAdminDasServices.GetAdminList(lo_objReqAdminList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResAdminList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAdminListExcel()
    {
        string                      lo_strAdminID      = string.Empty;
        string                      lo_strAdminName    = string.Empty;
        string                      lo_strMobileNo     = string.Empty;
        ReqAdminList                lo_objReqAdminList = null;
        ServiceResult<ResAdminList> lo_objResAdminList = null;
        string                      lo_strFileName     = string.Empty;
        SpreadSheet                 lo_objExcel        = null;
        DataTable                   lo_dtData          = null;
        MemoryStream                lo_outputStream    = null;
        byte[]                      lo_Content         = null;
        int                         lo_intColumnIndex  = 0;

        try
        {
            switch (strSearchType)
            {
                case "AdminID":
                    lo_strAdminID = strListSearch;
                    break;
                case "AdminName":
                    lo_strAdminName = strListSearch;
                    break;
                case "MobileNo":
                    lo_strMobileNo = strListSearch;
                    break;
            }

            lo_objReqAdminList = new ReqAdminList
            {
                AdminID          = lo_strAdminID,
                MobileNo         = lo_strMobileNo,
                AdminName        = lo_strAdminName,
                GradeCode        = intGradeCode,
                UseFlag          = strUseFlag,
                SesGradeCode     = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = 0,
                PageNo           = 0
            };

            lo_objResAdminList = objAdminDasServices.GetAdminList(lo_objReqAdminList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("아이디",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("휴대폰",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이름",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등급",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송사",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전화번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이메일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접속IP사용여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접속IP1",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접속IP2",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("접속IP3",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("24시콜 담당아이디", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물맨 담당아이디",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최근 접속일시",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최근 접속IP",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("가입일",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계정 만료일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("관리 운송사코드",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용 여부",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("중복로그인 여부",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("내오더만 조회 여부", typeof(string)));

            foreach (var row in lo_objResAdminList.data.list)
            {
                lo_dtData.Rows.Add(row.AdminID, row.MobileNo, row.AdminName, row.GradeCodeM, row.CenterName
                                  ,row.TelNo, row.Email, row.AccessIPChkFlag, row.AccessIP1, row.AccessIP2
                                  ,row.AccessIP3, row.Network24DDID, row.NetworkHMMID, row.LastLoginDate, row.LastLoginIP
                                  ,row.JoinYMD, row.ExpireYMD, row.AccessCenterCode, row.UseFlagM, row.DupLoginFlagM
                                  ,row.MyOrderFlagM);
            }

            lo_objExcel = new SpreadSheet {SheetName = "AdminList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.Yellow, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Right);
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

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsAdmin()
    {
        int                 lo_intRegReqType   = 0;
        string              lo_strAccessCorpNo = strAdminCorpNo;
        AdminViewModel      lo_objReqInsAdmin  = null;
        ServiceResult<bool> lo_objResInsAdmin  = null;

        try
        {
            switch (intGradeCode)
            {
                case 6:
                    lo_intRegReqType   = 2;
                    lo_strAccessCorpNo = strAccessCorpNo;
                    break;
                default:
                    lo_intRegReqType   = 1;
                    break;
            }

            lo_objReqInsAdmin = new AdminViewModel
            {
                AdminID          = strAdminID,
                AdminPwd         = strAdminPwd,
                MobileNo         = strMobileNo,
                AdminName        = strAdminName,
                GradeCode        = intGradeCode,
                AdminCorpNo      = strAdminCorpNo,
                AdminCorpName    = strAdminCorpName,
                DeptName         = strDeptName,
                TelNo            = strTelNo,
                Email            = strEmail,
                AdminPosition    = strAdminPosition,
                AccessIPChkFlag  = strAccessIPChkFlag,
                AccessIP1        = strAccessIP1,
                AccessIP2        = strAccessIP2,
                AccessIP3        = strAccessIP3,
                LastLoginDate    = strLastLoginDate,
                LastLoginIP      = strLastLoginIP,
                JoinYMD          = strJoinYMD,
                ExpireYMD        = strExpireYMD.Replace("-", ""),
                PwdUpdDate       = strPwdUpdDate,
                AccessCenterCode = strAccessCenterCode,
                AccessCorpNo     = lo_strAccessCorpNo,
                Network24DDID    = strNetwork24DDID,
                NetworkHMMID     = strNetworkHMMID,
                NetworkOneCallID = strNetworkOneCallID,
                NetworkHmadangID = strNetworkHmadangID,
                DupLoginFlag     = strDupLoginFlag,
                MyOrderFlag      = strMyOrderFlag,
                UseFlag          = strUseFlag,
                RegReqType       = lo_intRegReqType,
                RegAdminID       = objSes.AdminID,
                PrivateAvailFlag = strPrivateAvailFlag
            };

            lo_objResInsAdmin = objAdminDasServices.InsAdmin(lo_objReqInsAdmin);
            objResMap.RetCode = lo_objResInsAdmin.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsAdmin.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdAdmin()
    {
        int                 lo_intRegReqType   = 0;
        string              lo_strAccessCorpNo = strAdminCorpNo;
        AdminViewModel      lo_objReqUpdAdmin  = null;
        ServiceResult<bool> lo_objResUpdAdmin  = null;

        try
        {
            switch (intGradeCode)
            {
                case 6:
                    lo_intRegReqType   = 2;
                    lo_strAccessCorpNo = strAccessCorpNo;
                    break;
                default:
                    lo_intRegReqType   = 1;
                    break;
            }

            lo_objReqUpdAdmin = new AdminViewModel
            {
                AdminID          = strAdminID,
                MobileNo         = strMobileNo,
                AdminName        = strAdminName,
                GradeCode        = intGradeCode,
                AdminCorpNo      = strAdminCorpNo,
                AdminCorpName    = strAdminCorpName,
                AdminPosition    = strAdminPosition,
                DeptName         = strDeptName,
                TelNo            = strTelNo,
                Email            = strEmail,
                AccessIPChkFlag  = strAccessIPChkFlag,
                AccessIP1        = strAccessIP1,
                AccessIP2        = strAccessIP2,
                AccessIP3        = strAccessIP3,
                ExpireYMD        = strExpireYMD.Replace("-", ""),
                AccessCenterCode = strAccessCenterCode,
                AccessCorpNo     = lo_strAccessCorpNo,
                Network24DDID    = strNetwork24DDID,
                NetworkHMMID     = strNetworkHMMID,
                NetworkOneCallID = strNetworkOneCallID,
                NetworkHmadangID = strNetworkHmadangID,
                DupLoginFlag     = strDupLoginFlag,
                MyOrderFlag      = strMyOrderFlag,
                UseFlag          = strUseFlag,
                RegReqType       = lo_intRegReqType,
                RegAdminID       = objSes.AdminID,
                PrivateAvailFlag = strPrivateAvailFlag
            };

            lo_objResUpdAdmin = objAdminDasServices.UpdAdmin(lo_objReqUpdAdmin);
            objResMap.RetCode = lo_objResUpdAdmin.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdmin.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 접속 초기화
    /// </summary>
    protected void ResetLoginAdmin()
    {
        int                 lo_intRegReqType         = 0;
        ServiceResult<bool> lo_objResResetLoginAdmin = null;

        if (string.IsNullOrWhiteSpace(strAdminID))
        {
            objResMap.RetCode = 9903;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResResetLoginAdmin = objAdminDasServices.ResetLoginAdmin(strAdminID);
            objResMap.RetCode        = lo_objResResetLoginAdmin.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResResetLoginAdmin.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 신규 비밀번호 전송
    /// </summary>
    protected void SendPwdAdmin()
    {
        string              lo_strEncAdminResetPwd = string.Empty;
        int                 lo_intRetVal           = 0;
        ServiceResult<bool> lo_objUpdAdminPwd      = null;
        BCrypt              lo_objBCrypt           = new BCrypt();
        ResSendSMS          lo_objResSendSMS       = null;
        string              lo_strSmsContents      = string.Empty;

        if (string.IsNullOrWhiteSpace(strAdminID))
        {
            objResMap.RetCode = 9903;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            if (string.IsNullOrEmpty(strMobileNo))
            {
                objResMap.RetCode = 9551;
                objResMap.ErrMsg  = "휴대폰 번호가 없습니다.";
                return;
            }

            strAdminResetPwd = Guid.NewGuid().ToString().Right(8).Replace("-", "");

            lo_strEncAdminResetPwd = lo_objBCrypt.HashPassword(strAdminResetPwd, lo_objBCrypt.GenerateSaltByRandom());
            lo_objUpdAdminPwd      = objAdminDasServices.UpdAdminPwd(strAdminID, lo_strEncAdminResetPwd, objSes.AdminID, 2);
            lo_intRetVal           = lo_objUpdAdminPwd.result.ErrorCode;

            if (lo_intRetVal.IsFail())
            {
                objResMap.RetCode = lo_intRetVal;
                objResMap.ErrMsg  = lo_objUpdAdminPwd.result.ErrorMsg;
                return;
            }

            lo_strSmsContents = $"[로지스퀘어 매니저] {strAdminID}님의 임시패스워드는 '{strAdminResetPwd}' 입니다.";
            lo_objResSendSMS  = SiteGlobal.CallSMS(CommonConstant.DEFAULT_CENTER_CODE, CommonConstant.DEFAULT_SMS_TEL.Replace("-", ""), strMobileNo.Replace("-", ""), lo_strSmsContents);
            objResMap.RetCode = lo_objResSendSMS.Header.ResultCode;
            objResMap.ErrMsg  = lo_objResSendSMS.Header.ResultMessage;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
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

            SiteGlobal.WriteLog("AdminHandler", "Exception",
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