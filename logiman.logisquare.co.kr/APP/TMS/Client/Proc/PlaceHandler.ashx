<%@ WebHandler Language="C#" Class="PlaceHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : PlaceHandler.ashx
/// Description     : APP 상하차지 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : jylee88@logislab.com, 2022-12-22
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PlaceHandler : AppAshxBaseHandler
{
    // 메소드 리스트
    private const string      MethodClientPlaceChargeList       = "ClientPlaceChargeList";
    private const string      MethodPlaceList                   = "PlaceList";
    private const string      MethodClientPlaceChargeInsert     = "ClientPlaceChargeInsert";
    private const string      MethodClientPlaceChargeUpdate     = "ClientPlaceChargeUpdate";
    private const string      MethodChargeList                  = "ChargeList";
    private const string      MethodChargeInsert                = "ChargeInsert";

    AppClientPlaceDasServices         objAppClientPlaceChargeDasServices = new AppClientPlaceDasServices();
    ClientPlaceChargeDasServices      objClientPlaceChargeDasServices  = new ClientPlaceChargeDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string      strCenterCode       = string.Empty;
    private string      strUseFlag          = string.Empty;
    private string      strSearchType       = string.Empty;
    private string      strPlaceSearchType  = string.Empty;
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
    private string      strLocalCode        = string.Empty;
    private string      strLocalName        = string.Empty;
    private string      strPlaceRemark1     = string.Empty;
    private string      strPlaceRemark2     = string.Empty;
    private string      strPlaceRemark3     = string.Empty;
    private string      strPlaceRemark4     = string.Empty;
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

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {

        base.ProcessRequest(context);

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

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PlaceHandler");
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
            strPlaceSearchType      = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSearchType"), "0");
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
            strLocalCode            = Utils.IsNull(SiteGlobal.GetRequestForm("LocalCode"), "");
            strLocalName            = Utils.IsNull(SiteGlobal.GetRequestForm("LocalName"), "");
            strPlaceRemark1         = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceRemark1"), "");
            strPlaceRemark2         = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceRemark2"), "");
            strPlaceRemark3         = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceRemark3"), "");
            strPlaceRemark4         = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceRemark4"), "");
            strSeqNos1              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos1"), "");
            strSeqNos2              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos2"), "");
            strSeqNos3              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos3"), "");
            strSeqNos4              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos4"), "");
            strSeqNos5              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNos5"), "");
            strSido                 = Utils.IsNull(SiteGlobal.GetRequestForm("Sido"), "");
            strGugun                = Utils.IsNull(SiteGlobal.GetRequestForm("Gugun"), "");
            strDong                 = Utils.IsNull(SiteGlobal.GetRequestForm("Dong"), "");
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
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
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodClientPlaceChargeInsert:
                    ClientPlaceChargeIns();
                    break;
                case MethodClientPlaceChargeUpdate:
                    GetChargeUpdate();
                    break;
                case MethodChargeList:
                    GetChargeList();
                    break;
                case MethodChargeInsert:
                    GetChargeInsert();
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

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
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
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqAppClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResAppClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

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

            lo_objReqClinetPlaceChargeList = new ReqAppClientPlaceChargeList
            {
                CenterCode      = strCenterCode.ToInt(),
                UseFlag         = strUseFlag,
                PlaceName       = lo_strPlaceName,
                ChargeName      = lo_strChargeName,
                GradeCode       = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo    = objSes.AccessCorpNo,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objResClientPlaceChargeList    = objAppClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 불러오기
    /// </summary>
    protected void GetPlaceList()
    {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqAppClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResAppClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

        try
        {
            lo_objReqClinetPlaceChargeList = new ReqAppClientPlaceChargeList
            {
                PlaceSeqNo      = strPlaceSeqNo.ToInt64(),
                CenterCode      = strCenterCode.ToInt(),
                SearchType      = strPlaceSearchType.ToInt(),
                PlaceName       = strPlaceName,
                UseFlag         = strUseFlag,
                GradeCode       = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };
                
            lo_objResClientPlaceChargeList    = objAppClientPlaceChargeDasServices.GetAppClientPlaceList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    protected void ClientPlaceChargeIns() {
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
                ClientCode              = strClientCode.ToInt(),
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
                LocalCode               = strLocalCode,

                LocalName               = strLocalName,
                PlaceRemark1            = strPlaceRemark1,
                PlaceRemark2            = strPlaceRemark2,
                PlaceRemark3            = strPlaceRemark3,
                PlaceRemark4            = strPlaceRemark4,

                AdminID = objSes.AdminID
            };

            lo_objResClientPlaceChargeIns    = objClientPlaceChargeDasServices.InsClientPlaceCharge(lo_objReqClientPlaceChargeIns);
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

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChargeUpdate() {
        ClientPlaceChargeViewModel        lo_objReqClientPlaceChargeIns = null;
        ServiceResult<bool>               lo_objResClientPlaceChargeIns = null;
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
                PlaceSeqNo              = strPlaceSeqNo.ToInt64(),
                ClientCode              = strClientCode.ToInt(),
                PlacePost               = strPlacePost,
                PlaceAddr               = strPlaceAddr,
                PlaceAddrDtl            = strPlaceAddrDtl,

                Sido                    = strSido,
                Gugun                   = strGugun,
                Dong                    = strDong,
                FullAddr                = strSido + " " + strGugun + " " + strDong,
                LocalCode               = strLocalCode,

                LocalName               = strLocalName,
                PlaceRemark1            = strPlaceRemark1,
                PlaceRemark2            = strPlaceRemark2,
                PlaceRemark3            = strPlaceRemark3,
                PlaceRemark4            = strPlaceRemark4,

                UseFlag                 = strUseFlag,
                AdminID                 = objSes.AdminID
            };

            lo_objResClientPlaceChargeIns    = objClientPlaceChargeDasServices.UpdCharge(lo_objReqClientPlaceChargeIns);
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
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 불러오기
    /// </summary>
    protected void GetChargeList()
    {
        string      lo_strPlaceName        = string.Empty;
        string      lo_strChargeName       = string.Empty;

        ReqClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

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

            lo_objResClientPlaceChargeList    = objClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 담당자 등록
    /// </summary>
    protected void GetChargeInsert() {
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
                PlaceSeqNo              = strPlaceSeqNo.ToInt64(),
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

            lo_objResClientPlaceChargeIns    = objClientPlaceChargeDasServices.InsCharge(lo_objReqClientPlaceChargeIns);
            objResMap.RetCode  = lo_objResClientPlaceChargeIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientPlaceChargeIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9412;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PlaceHandler", "Exception",
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