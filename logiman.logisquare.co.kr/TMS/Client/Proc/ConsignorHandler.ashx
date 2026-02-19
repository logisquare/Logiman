<%@ WebHandler Language="C#" Class="ConsignorHandler" %>
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
/// FileName        : ConsignorHandler.ashx
/// Description     : 화주 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : sybyun96@logislab.com, 2022-07-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ConsignorHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Client/ConsignorList"; //필수

    // 메소드 리스트
    private const string MethodConsignorList       = "ConsignorList";
    private const string MethodConsignorListExcel  = "ConsignorListExcel";
    private const string MethodConsignorIns        = "ConsignorInsert";
    private const string MethodConsignorUpd        = "ConsignorUpdate";
    private const string MethodClientList          = "ClientList";
    private const string MethodClientConsignorList = "ClientConsignorList";
    private const string MethodClientConsignorIns  = "ClientConsignorInsert";
    private const string MethodClientConsignorDel  = "ClientConsignorDelete";

    ConsignorDasServices objConsignorDasServices   = new ConsignorDasServices();
    ClientDasServices    objClientDasServices      = new ClientDasServices();
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
        objMethodAuthList.Add(MethodConsignorList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorListExcel,  MenuAuthType.All);
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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ConsignorHandler");
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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodConsignorListExcel:
                    GetConsignorListExcel();
                    break;
                case MethodConsignorIns:
                    SetConsignorIns();
                    break;
                case MethodConsignorUpd:
                    SetConsignorUpd();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientConsignorList:
                    GetClientConsignorList();
                    break;
                case MethodClientConsignorIns:
                    SetClientConsignorIns();
                    break;
                case MethodClientConsignorDel:
                    SetClientConsignorDel();
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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 화주 목록
    /// </summary>
    protected void GetConsignorList()
    {
        ReqConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResConsignorList> lo_objResConsignorList = null;

        try
        {
            lo_objReqConsignorList = new ReqConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = strUseFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorList = objConsignorDasServices.GetConsignorList(lo_objReqConsignorList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 엑셀 다운로드
    /// </summary>
    protected void GetConsignorListExcel()
    {
        ReqConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResConsignorList> lo_objResConsignorList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqConsignorList = new ReqConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = strUseFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorList = objConsignorDasServices.GetConsignorList(lo_objReqConsignorList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사용여부",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록자아이디", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("등록일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수정자아이디", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("수정일", typeof(string)));

            foreach (var row in lo_objResConsignorList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.ConsignorName, row.ConsignorNote,row.UseFlag, row.RegAdminID
                                , row.RegDate, row.UpdAdminID, row.UpdDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "ConsignorList"};

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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 등록
    /// </summary>
    protected void SetConsignorIns()
    {
        ConsignorModel                lo_objConsignorModel  = null;
        ServiceResult<ConsignorModel> lo_objResConsignorIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorModel = new ConsignorModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                ConsignorNote    = strConsignorNote,
                RegAdminID       = objSes.AdminID
            };

            lo_objResConsignorIns = objConsignorDasServices.SetConsignorIns(lo_objConsignorModel);
            objResMap.RetCode     = lo_objResConsignorIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ConsignorCode",    lo_objResConsignorIns.data.ConsignorCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 수정
    /// </summary>
    protected void SetConsignorUpd()
    {
        ConsignorModel      lo_objConsignorModel  = null;
        ServiceResult<bool> lo_objResConsignorUpd = null;

        strUseFlag = Utils.IsNull(strUseFlag, "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorModel = new ConsignorModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                ConsignorNote    = strConsignorNote,
                UseFlag          = strUseFlag,
                UpdAdminID       = objSes.AdminID
            };

            lo_objResConsignorUpd = objConsignorDasServices.SetConsignorUpd(lo_objConsignorModel);
            objResMap.RetCode     = lo_objResConsignorUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ConsignorCode", strConsignorCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 - 화주 연결정보 목록
    /// </summary>
    protected void GetClientConsignorList()
    {
        ReqClientConsignorList                lo_objReqClientConsignorList = null;
        ServiceResult<ResClientConsignorList> lo_objResClientConsignorList = null;

        try
        {
            lo_objReqClientConsignorList = new ReqClientConsignorList
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                DelFlag          = "N",
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientConsignorList = objClientDasServices.GetClientConsignorList(lo_objReqClientConsignorList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResClientConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 - 화주 연결정보 등록
    /// </summary>
    protected void SetClientConsignorIns()
    {
        ClientConsignorModel                lo_objClientConsignorModel  = null;
        ServiceResult<ClientConsignorModel> lo_objResClientConsignorIns = null;

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


        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }


        try
        {
            lo_objClientConsignorModel = new ClientConsignorModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                RegAdminID       = objSes.AdminID
            };

            lo_objResClientConsignorIns = objClientDasServices.SetClientConsignorIns(lo_objClientConsignorModel);
            objResMap.RetCode     = lo_objResClientConsignorIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientConsignorIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo", lo_objResClientConsignorIns.data.SeqNo);
                objResMap.Add("EncSeqNo", Utils.GetEncrypt(lo_objResClientConsignorIns.data.SeqNo.ToString()));
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 - 화주 연결정보 삭제
    /// </summary>
    protected void SetClientConsignorDel()
    {
        ServiceResult<bool> lo_objResClientConsignorDel = null;
        string              lo_strSeqNo                 = string.Empty;

        if (string.IsNullOrWhiteSpace(strEncSeqNo) || strEncSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        lo_strSeqNo = Utils.GetDecrypt(strEncSeqNo);
            
        if (string.IsNullOrWhiteSpace(lo_strSeqNo) || lo_strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResClientConsignorDel = objClientDasServices.SetClientConsignorDel(lo_strSeqNo.ToInt(), objSes.AdminID);

            objResMap.RetCode = lo_objResClientConsignorDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientConsignorDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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