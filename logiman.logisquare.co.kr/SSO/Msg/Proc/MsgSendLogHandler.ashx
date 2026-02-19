<%@ WebHandler Language="C#" Class="MsgSendLogHandler" %>
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
/// FileName        : MsgSendLogHandler.ashx
/// Description     : 메시지 전송 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-04-06
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class MsgSendLogHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Msg/MsgSendLogList"; //필수

    // 메소드 리스트
    private const string MethodMsgSendLogList      = "MsgSendLogList";
    private const string MethodMsgSendLogListExcel = "MsgSendLogListExcel";
    MsgDasServices       objMsgDasServices         = new MsgDasServices();

    private string strCallType       = string.Empty;

    private int    intPageSize         = 0;
    private int    intPageNo           = 0;
    private string strSeqNo            = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strMsgType          = string.Empty;
    private string strRcvNum           = string.Empty;
    private string strSendNum          = string.Empty;
    private string strRetCodeType      = string.Empty;
    private string strFromYMD          = string.Empty;
    private string strToYMD            = string.Empty;
    private string strSearchType       = string.Empty;
    private string strListSearch       = string.Empty;
    private string strAccessCenterCode = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodMsgSendLogList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodMsgSendLogListExcel, MenuAuthType.All);

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

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("MsgSendLogHandler");
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
            strSearchType       = SiteGlobal.GetRequestForm("SearchType");
            strListSearch       = SiteGlobal.GetRequestForm("ListSearch");
            strSeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),   "0");
            strMsgType          = Utils.IsNull(SiteGlobal.GetRequestForm("MsgType"), "0");
            strRcvNum           = SiteGlobal.GetRequestForm("RcvNum");
            strSendNum          = SiteGlobal.GetRequestForm("SendNum");
            strRetCodeType      = Utils.IsNull(SiteGlobal.GetRequestForm("RetCodeType"), "0");
            strFromYMD          = SiteGlobal.GetRequestForm("FromYMD");
            strToYMD            = SiteGlobal.GetRequestForm("ToYMD");
            strAccessCenterCode = objSes.AccessCenterCode;

            if (!string.IsNullOrWhiteSpace(strFromYMD))
            {
                strFromYMD = Utils.ReplaceString4Numeric(strFromYMD);
            }

            if (!string.IsNullOrWhiteSpace(strToYMD))
            {
                strToYMD = Utils.ReplaceString4Numeric(strToYMD);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
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
                case MethodMsgSendLogList:
                    GetMsgSendLogList();
                  break;
                case MethodMsgSendLogListExcel:
                    GetMsgSendLogListExcel();
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

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 메시지 전송 내역 목록
    /// </summary>
    protected void GetMsgSendLogList()
    {
        ReqMsgSendLogList                lo_objReqMsgSendLogList = null;
        ServiceResult<ResMsgSendLogList> lo_objResMsgSendLogList = null;

        try
        {
            switch (strSearchType)
            {
                case "SendNum":
                    strSendNum = strListSearch;
                    break;
                case "RcvNum":
                    strRcvNum = strListSearch;
                    break;
            }

            lo_objReqMsgSendLogList = new ReqMsgSendLogList
            {   
                CenterCode       = strCenterCode.ToInt(),
                MsgType          = strMsgType.ToInt(),
                RcvNum           = strRcvNum,
                SendNum          = strSendNum,
                RetCodeType      = strRetCodeType.ToInt(),
                FromYMD          = strFromYMD,
                ToYMD            = strToYMD,
                AccessCenterCode = strAccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResMsgSendLogList = objMsgDasServices.GetMsgSendLogList(lo_objReqMsgSendLogList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResMsgSendLogList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 메시지 전송내역 엑셀 다운로드
    /// </summary>
    protected void GetMsgSendLogListExcel()
    {
        ReqMsgSendLogList                lo_objReqMsgSendLogList = null;
        ServiceResult<ResMsgSendLogList> lo_objResMsgSendLogList = null;

        string       lo_strFileName  = "";
        SpreadSheet  lo_objExcel     = null;
        DataTable    lo_dtData       = null;
        MemoryStream lo_outputStream = null;
        byte[]       lo_Content      = null;
        int          lo_intColumnCnt = 1;

        try
        {
            switch (strSearchType)
            {
                case "SendNum":
                    strSendNum = strListSearch;
                    break;
                case "RcvNum":
                    strRcvNum = strListSearch;
                    break;
            }

            lo_objReqMsgSendLogList = new ReqMsgSendLogList
            {   
                CenterCode       = strCenterCode.ToInt(),
                MsgType          = strMsgType.ToInt(),
                RcvNum           = strRcvNum,
                SendNum          = strSendNum,
                RetCodeType      = strRetCodeType.ToInt(),
                FromYMD          = strFromYMD,
                ToYMD            = strToYMD,
                AccessCenterCode = strAccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResMsgSendLogList = objMsgDasServices.GetMsgSendLogList(lo_objReqMsgSendLogList);
            
            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사코드",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("알림서비스유형", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발신번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수신번호",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("제목",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("본문",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오류여부",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("PG오류코드", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("PG오류메시지", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발송일시",    typeof(string)));

            foreach (var row in lo_objResMsgSendLogList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterCode, row.CenterName, row.MsgTypeM, row.SendNum, row.RcvNum
                                  ,row.Title, row.Contents, row.ReceiptNum, row.RetCodeM, row.PGRetCode
                                  ,row.PGRetMsg, row.RegDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "MsgSendLog"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Left);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");

            lo_objExcel.SetColumnFormat(lo_intColumnCnt++,  0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++,  0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++,  0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++,  0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");

            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");
            lo_objExcel.SetColumnFormat(lo_intColumnCnt++, 0, "");

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

            SiteGlobal.WriteLog("MsgSendLogHandler", "Exception",
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