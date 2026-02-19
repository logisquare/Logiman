<%@ WebHandler Language="C#" Class="OrderPrintListHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using System;
using System.Web;
using CommonLibrary.Extensions;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : OrderPrintListHandler.ashx
/// Description     : 출력물 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemSmsContent
/// Author          : jylee88@logislab.com, 2022-08-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderPrintListHandler : AshxBaseHandler
{
    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();
    ClientDasServices        objClientDasServices        = new ClientDasServices();
    SaleDasServices          objSaleDasServices          = new SaleDasServices();
    
    private string strCallType         = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strOrderNos         = string.Empty;
    private string strOrderNos1        = string.Empty;
    private string strOrderNos2        = string.Empty;
    private string strSaleClosingSeqNo = string.Empty;
    private string strClientCode       = string.Empty;
    private string strDateType         = string.Empty;
    private string strDateFrom         = string.Empty;
    private string strDateTo           = string.Empty;
    private string strChargeName       = string.Empty;
    private string strSaleOrgAmt       = string.Empty;
    private string strRecName          = string.Empty;
    private string strRecMail          = string.Empty;
    private string strSendMail         = string.Empty;
    private string strClosingFlag      = string.Empty;
    private string strAdminName        = string.Empty;
    private string strAdminID          = string.Empty;
    private string strCenterName       = string.Empty;
    private string strClientName       = string.Empty;
    private string strMailTitle        = string.Empty;
    private string strAdminTel         = string.Empty;
    private string strAdminMobile      = string.Empty;
    private string strDeptName         = string.Empty;
    private string strAdminPosition    = string.Empty;
    private string strAdminMail        = string.Empty;
    private string strPrintUrl         = string.Empty;
    private int    intPageSize         = 0;
    private int    intPageNo           = 0;

    #region IHttpHandler Members
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //NOTICE:로그인 체크가 필요없는 핸들러인 경우 호출 - 반드시 base.ProcessRequest 구문상단에서 호출해야 함
        IgnoreCheckSession();

        //0.초기화 및 세션티켓 검증
        //# 부모 클래스의 함수 호출
        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"), "");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();
            //1.Request
            GetData();
            if (objResMap.RetCode.IsFail())
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

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderPrintListHandler");
        }
    }

    #endregion

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
            strOrderNos         = SiteGlobal.GetRequestForm("OrderNos");
            strOrderNos1        = SiteGlobal.GetRequestForm("OrderNos1");
            strOrderNos2        = SiteGlobal.GetRequestForm("OrderNos2");
            strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            strClientCode       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strDateType         = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom         = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo           = SiteGlobal.GetRequestForm("DateTo");
            strCenterCode       = SiteGlobal.GetRequestForm("CenterCode");
            strChargeName       = SiteGlobal.GetRequestForm("ChargeName");
            strSaleOrgAmt       = Utils.IsNull(SiteGlobal.GetRequestForm("SaleOrgAmt"), "0");
            strRecName          = SiteGlobal.GetRequestForm("RecName");
            strRecMail          = SiteGlobal.GetRequestForm("RecMail");
            strSendMail         = SiteGlobal.GetRequestForm("SendMail");
            strClosingFlag      = SiteGlobal.GetRequestForm("ClosingFlag");
            strAdminName        = SiteGlobal.GetRequestForm("AdminName");
            strAdminID          = SiteGlobal.GetRequestForm("AdminID");
            strPrintUrl         = SiteGlobal.GetRequestForm("PrintUrl");
            strClientName       = SiteGlobal.GetRequestForm("ClientName");
            strMailTitle        = SiteGlobal.GetRequestForm("MailTitle");
            strAdminTel         = SiteGlobal.GetRequestForm("AdminTel");
            strAdminMobile      = SiteGlobal.GetRequestForm("AdminMobile");
            strDeptName         = SiteGlobal.GetRequestForm("DeptName");
            strAdminPosition    = SiteGlobal.GetRequestForm("AdminPosition");
            strCenterName       = SiteGlobal.GetRequestForm("CenterName");
            strAdminMail        = SiteGlobal.GetRequestForm("AdminMail");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
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
                case "OrderDispatchPrintList":
                    GetOrderDispatchPrintList();
                    break;
                case "OrderDispatchDomesticPrintList":
                    GetOrderDispatchDomesticPrintList();
                    break;
                case "OrderDispatchAdvanceList":
                    GetOrderDispatchAdvanceList();
                    break;
                case "ChargeNameList":
                    GetChargeNameList();
                    break;
                case "PrintSendMail":
                    GetPrintSendMail();
                    break;
                case "SaleClosingSendMail":
                    SetSaleClosingSendMail();
                    break;
                case "DownloadPdfPrint":
                    SetDownloadPdfPrint();
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

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 수출입 출력 목록
    /// </summary>
    protected void GetOrderDispatchPrintList()
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;
        int                                 lo_intListType     = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strSaleClosingSeqNo.Equals("0"))
        {
            if (string.IsNullOrWhiteSpace(strOrderNos) || strOrderNos.Equals(""))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else
        {
            if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos1        = strOrderNos,
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                ClientCode       = strClientCode.ToInt64(),
                ListType         = lo_intListType.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo
            };

            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchPrintList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 출력 목록
    /// </summary>
    protected void GetOrderDispatchDomesticPrintList()
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;
        int                                 lo_intListType     = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strSaleClosingSeqNo.Equals("0"))
        {
            if (string.IsNullOrWhiteSpace(strOrderNos) || strOrderNos.Equals(""))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else
        {
            if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos         = strOrderNos,
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                ClientCode       = strClientCode.ToInt64(),
                ListType         = lo_intListType.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo
            };

            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchDomesticPrintList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";

            objResMap.Add("AcctNo", lo_objResOrderList.data.list[0].EncAcctNoInfo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchAdvanceList() 
    { 
        ReqOrderDispatchList                       lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchAdvanceList> lo_objResOrderList = null;
        int                                        lo_intListType     = 1;
            
        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNos1  = strOrderNos,
                ClientCode = strClientCode.ToInt64()
            };
                
            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchAdvanceList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetChargeNameList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

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

        if (string.IsNullOrWhiteSpace(strChargeName))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        try
        {
            lo_objReqClientSearchList = new ReqClientSearchList
            {
                CenterCode    = strCenterCode.ToInt(),
                ClientCode    = strClientCode.ToInt(),
                UseFlag       = "Y",
                ChargeName    = strChargeName,
                ChargeUseFlag = "Y",
                PageSize      = intPageSize,
                PageNo        = intPageNo
            };
            
            lo_objResClientSearchList = objClientDasServices.GetClientSearchList(lo_objReqClientSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetSaleClosingSendMail()
    {

        ReqSaleClosingIns                lo_objReqSaleClosingIns = null;
        ServiceResult<ResSaleClosingIns> lo_objResSaleClosingIns = null;
        int                              lo_intClosingKind       = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos1))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingIns = new ReqSaleClosingIns
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos1        = strOrderNos1,
                OrderNos2        = strOrderNos2,
                SaleOrgAmt       = strSaleOrgAmt.ToDouble(),
                ClosingKind      = lo_intClosingKind,
                ClosingAdminID   = strAdminID,
                ClosingAdminName = strAdminName
            };
                
            lo_objResSaleClosingIns = objSaleDasServices.SetSaleClosingIns(lo_objReqSaleClosingIns);
            objResMap.RetCode       = lo_objResSaleClosingIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingIns.result.ErrorMsg;
                return;
            }
             
            GetPrintSendMail();
            objResMap.Add("SaleClosingSeqNo",   lo_objResSaleClosingIns.data.SaleClosingSeqNo.ToString());
            objResMap.Add("SaleOrgAmt", lo_objResSaleClosingIns.data.SaleOrgAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9204;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetPrintSendMail()
    {
        try
        {
            string lo_strEmail_Cnts     = string.Empty;
            string lo_strEmail_CONTENTS = string.Empty;
            string lo_strEmail_title    = string.Empty;
            bool   bRslt                = true;
            string lo_strParam          = string.Empty;
            string lo_strFileName       = "운송내역서_" + DateTime.Now.ToString("yyyyMMddHHmmss");
            string lo_strFileSendName   = lo_strFileName.Substring(0, 14) + ".pdf";
            Random lo_rnd               = new Random();
        
            lo_strFileName += lo_rnd.Next(100000, 1000000) + ".pdf";

            lo_strParam =  "CenterCode=" + strCenterCode;
            lo_strParam += "&ClientCode=" + strClientCode;
            lo_strParam += "&SaleClosingSeqNo=" + strSaleClosingSeqNo;
            lo_strParam += "&OrderNos1=" + strOrderNos1;
            lo_strParam += "&OrderNos2=" + strOrderNos2;
            lo_strParam += "&UserAddr=" + SiteGlobal.GetRemoteAddr();
            lo_strParam += "&PdfFlag=Y";

            lo_strEmail_title =  strClientName + " " + strMailTitle;
            lo_strEmail_Cnts  += strClientName + " " + strMailTitle + "발송 드립니다.<br>";
            lo_strEmail_Cnts  += "이상 여부 또는 계산서 발행 여부 회신 부탁드립니다.<br><br><br>";
            lo_strEmail_Cnts  += "<div style=\"font-size:12px; font-weight:600; line-height:1.5;\">";
            lo_strEmail_Cnts  += "(주)로지스퀘어 Logisquare | " + strDeptName + " | " + strAdminPosition + " " + strAdminName + "<br>";
            lo_strEmail_Cnts  += Utils.GetMobileNoDashed(strAdminTel) + " | " + Utils.GetMobileNoDashed(strAdminMobile) + "<br>";
            lo_strEmail_Cnts  += "Email : <a href=\"mailto:" + strAdminMail + "\">"+ strAdminMail + "</a> | Website : <a href=\"https://www.logisquare.co.kr/\" target=\"_blank\">www.logisquare.co.kr</a><br><br>";
            lo_strEmail_Cnts  += "(주)로지스퀘어는 법규를 준수하며 리베이트를 수수하지 않습니다.";
            lo_strEmail_Cnts  += "</div>";

            bRslt = SiteGlobal.SendWebUrlPdfToEmail(strPrintUrl, lo_strParam, 1, 10, 10, 10, 10, 100, lo_strFileName, lo_strFileSendName,
                                                    strSendMail, strRecMail, lo_strEmail_title, lo_strEmail_Cnts, strAdminMail);
            
            if (bRslt)
            {
                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "다운로드 성공";
                //내역서 히스토리 저장
                SetPrintHistoryIns();
            }else{
                objResMap.RetCode = 9277;
                objResMap.ErrMsg  = "다운로드 실패";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9205;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetPrintHistoryIns()
    {
        PrintHistoryModel                lo_objReqPrintHistoryModel = null;
        ServiceResult<PrintHistoryModel> lo_objResPrintHistoryModel = null;
            
        try
        {
            lo_objReqPrintHistoryModel = new PrintHistoryModel
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos1        = strOrderNos1,
                OrderNos2        = strOrderNos2,
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                RecName          = strRecName,
                RecMail          = strRecMail,
                SendName         = strAdminName,
                SendMail         = strSendMail,
                ClosingFlag      = strClosingFlag
            };

            lo_objResPrintHistoryModel = objOrderDispatchDasServices.SetOrderPrintHistIns(lo_objReqPrintHistoryModel);
            objResMap.RetCode          = lo_objResPrintHistoryModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPrintHistoryModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9206;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetDownloadPdfPrint()
    {
        string lo_strParam        = string.Empty;
        string lo_strFileName     = "운송내역서_" + DateTime.Now.ToString("yyyyMMddHHmmss");
        string lo_strFileDownName = lo_strFileName + ".pdf";
        Random lo_rnd             = new Random();
        
        lo_strFileName += lo_rnd.Next(100000, 1000000) + ".pdf";
            
        lo_strParam =  "CenterCode=" + strCenterCode;
        lo_strParam += "&ClientCode=" + strClientCode;
        lo_strParam += "&SaleClosingSeqNo=" + strSaleClosingSeqNo;
        lo_strParam += "&OrderNos1=" + strOrderNos1;
        lo_strParam += "&OrderNos2=" + strOrderNos2;
        lo_strParam += "&UserAddr=" + SiteGlobal.GetRemoteAddr();
        lo_strParam += "&PdfFlag=Y";
        
        try
        {
            bool bRslt = SiteGlobal.DownloadWebUrlPdf(strPrintUrl, lo_strParam, 1, 10, 10, 10, 10,
                                                      100, lo_strFileName, lo_strFileDownName);
            if (bRslt)
            {
                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "다운로드 성공";
            }else{
                objResMap.RetCode = 9277;
                objResMap.ErrMsg  = "다운로드 실패";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9207;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintListHandler", "Exception",
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