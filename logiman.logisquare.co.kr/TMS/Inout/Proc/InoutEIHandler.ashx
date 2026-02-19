<%@ WebHandler Language="C#" Class="InoutEIHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : InoutEIHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-06-05
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutEIHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Inout/InoutEIList"; //필수

    // 메소드 리스트
    //private const string MethodEdiWorkdOrderListExcel = "EdiWorkdOrderListExcel"; //EI 오더 내역 엑셀
    private const string MethodEdiWorkOrderList     = "EdiWorkOrderList";        //EI 오더 내역
    private const string MethodEdiStopList          = "EdiStopList";             //EI 상하차지 내역
    private const string MethodEdiEquipmentList     = "EdiEquipmentList";        //EI 화물 내역
    private const string MethodDispatchCarStatusUpd = "DispatchCarStatusUpdate"; //배차차량 상태 변경
    private const string MethodEdiReject            = "EdiReject";               //EI 오더 Reject
    private const string MethodEdiPOD               = "EdiPOD";                  //EI 오더 POD
    
    OrderDasServices    objOrderDasServices = new OrderDasServices();
    private HttpContext objHttpContext      = null;

    private string strCallType               = string.Empty;
    private int    intPageSize               = 0;
    private int    intPageNo                 = 0;
    private string strCenterCode             = string.Empty;
    private string strDateType               = string.Empty;
    private string strDateFrom               = string.Empty;
    private string strDateTo                 = string.Empty;
    private string strWorkOrderNumber        = string.Empty;
    private string strOrderNo                = string.Empty;
    private string strWorkOrderStatuses      = string.Empty;
    private string strCreatedBy              = string.Empty;
    private string strMasterAirWayBillNumber = string.Empty;
    private string strHouseAirWayBillNumber  = string.Empty;
    private string strMyOrderFlag            = string.Empty;
    private string strEqSeqNo                = string.Empty;
    private string strStSeqNo                = string.Empty;
    private string strStopType               = string.Empty;
    private string strStopName               = string.Empty;
    private string strRejectReasonCode       = string.Empty;
    private string strDispatchSeqNo          = string.Empty;
    private string strPickupDT               = string.Empty;
    private string strArrivalDT              = string.Empty;
    private string strGetDT                  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        //objMethodAuthList.Add(MethodEdiWorkdOrderListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodEdiWorkOrderList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodEdiStopList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodEdiEquipmentList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDispatchCarStatusUpd, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodEdiReject,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodEdiPOD,               MenuAuthType.ReadWrite);
        
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

            SiteGlobal.WriteLog("InoutEIHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutEIHandler");
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
            strCenterCode             = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType               = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom               = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                 = SiteGlobal.GetRequestForm("DateTo");
            strWorkOrderNumber        = SiteGlobal.GetRequestForm("WorkOrderNumber");
            strOrderNo                = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strWorkOrderStatuses      = SiteGlobal.GetRequestForm("WorkOrderStatuses");
            strCreatedBy              = SiteGlobal.GetRequestForm("CreatedBy");
            strMasterAirWayBillNumber = SiteGlobal.GetRequestForm("MasterAirWayBillNumber");
            strHouseAirWayBillNumber  = SiteGlobal.GetRequestForm("HouseAirWayBillNumber");
            strMyOrderFlag            = SiteGlobal.GetRequestForm("MyOrderFlag");
            strEqSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("EqSeqNo"), "0");
            strStSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("StSeqNo"), "0");
            strStopType               = SiteGlobal.GetRequestForm("StopType");
            strStopName               = SiteGlobal.GetRequestForm("StopName");
            strRejectReasonCode       = SiteGlobal.GetRequestForm("RejectReasonCode");
            strDispatchSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPickupDT               = SiteGlobal.GetRequestForm("PickupDT");
            strArrivalDT              = SiteGlobal.GetRequestForm("ArrivalDT");
            strGetDT                  = SiteGlobal.GetRequestForm("GetDT");

            strDateFrom         = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo           = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception",
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
                case MethodEdiWorkOrderList:
                    GetEdiWorkOrderList();
                    break;
                //case MethodEdiWorkOrderListExcel:
                //    GetEdiWorkOrderListExcel();
                //    break;
                case MethodEdiStopList:
                    GetEdiStopList();
                    break;
                case MethodEdiEquipmentList:
                    GetEdiEquipmentList();
                    break;
                case MethodDispatchCarStatusUpd:
                    SetDispatchCarStatusUpd();
                    break;
                case MethodEdiReject:
                    SetEdiReject();
                    break;
                case MethodEdiPOD:
                    SetPODFileUpload();
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

            SiteGlobal.WriteLog("InoutEIHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// EDI 오더 내역
    /// </summary>
    protected void GetEdiWorkOrderList()
    {
        ReqEdiWorkOrderList                lo_objReqEdiWorkOrderList = null;
        ServiceResult<ResEdiWorkOrderList> lo_objResEdiWorkOrderList = null;

        try
        {
            lo_objReqEdiWorkOrderList = new ReqEdiWorkOrderList
            {
                WorkOrderNumber        = strWorkOrderNumber,
                OrderNo                = strOrderNo.ToInt64(),
                CenterCode             = strCenterCode.ToInt(),
                DateType               = strDateType.ToInt(),
                DateFrom               = strDateFrom,
                DateTo                 = strDateTo,
                WorkOrderStatuses      = strWorkOrderStatuses,
                CreatedBy              = strCreatedBy,
                MasterAirWayBillNumber = strMasterAirWayBillNumber,
                HouseAirWayBillNumber  = strHouseAirWayBillNumber,
                MyOrderFlag            = strMyOrderFlag,
                AdminID                = objSes.AdminID,
                AccessCenterCode       = objSes.AccessCenterCode,
                PageSize               = 100000,
                PageNo                 = 1
            };

            lo_objResEdiWorkOrderList = objOrderDasServices.GetEdiWorkOrderList(lo_objReqEdiWorkOrderList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResEdiWorkOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }
    }

    /// <summary>
    /// EDI 상하차지 내역
    /// </summary>
    protected void GetEdiStopList()
    {
        ReqEdiStopList                lo_objReqEdiStopList = null;
        ServiceResult<ResEdiStopList> lo_objResEdiStopList = null;

        try
        {
            lo_objReqEdiStopList = new ReqEdiStopList
            {
                StSeqNo                = strStSeqNo.ToInt64(),
                WorkOrderNumber        = strWorkOrderNumber,
                OrderNo                = strOrderNo.ToInt64(),
                CenterCode             = strCenterCode.ToInt(),
                StopType               = strStopType,
                StopName               = strStopName,
                AccessCenterCode       = objSes.AccessCenterCode
            };

            lo_objResEdiStopList  = objOrderDasServices.GetEdiStopList(lo_objReqEdiStopList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResEdiStopList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }
    }

    /// <summary>
    /// EDI 화물 내역
    /// </summary>
    protected void GetEdiEquipmentList()
    {
        ReqEdiEquipmentList                lo_objReqEdiEquipmentList = null;
        ServiceResult<ResEdiEquipmentList> lo_objResEdiEquipmentList = null;

        try
        {
            lo_objReqEdiEquipmentList = new ReqEdiEquipmentList
            {
                EqSeqNo          = strEqSeqNo.ToInt64(),
                WorkOrderNumber  = strWorkOrderNumber,
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResEdiEquipmentList = objOrderDasServices.GetEdiEquipmentList(lo_objReqEdiEquipmentList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResEdiEquipmentList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }
    }

    /// <summary>
    /// 배차 상태 변경
    /// </summary>
    protected void SetDispatchCarStatusUpd()
    {
        ReqOrderDispatchCarStatusUpd lo_objReqOrderDispatchCarStatusUpd = null;
        ServiceResult<bool>          lo_objResOrderDispatchCarStatusUpd = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strDispatchSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strDispatchSeqNo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchCarStatusUpd = new ReqOrderDispatchCarStatusUpd
            {
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                DispatchSeqNo = strDispatchSeqNo.ToInt64(),
                PickupDT      = strPickupDT,
                ArrivalDT     = strArrivalDT,
                GetDT         = strGetDT,
                AdminID       = objSes.AdminID,
                AdminName     = objSes.AdminName,
            };

            lo_objResOrderDispatchCarStatusUpd = objOrderDasServices.SetOrderDispatchCarStatusUpd(lo_objReqOrderDispatchCarStatusUpd);
            objResMap.RetCode                  = lo_objResOrderDispatchCarStatusUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchCarStatusUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// EDI 오더 상태 변경 요청
    /// </summary>
    protected void SetEdiReject()
    {
        ReqEdiWorkOrderProcStateUpd lo_objReqEdiWorkOrderProcStateUpd = null;
        ServiceResult<bool>         lo_objResEdiWorkOrderProcStateUpd = null;


        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRejectReasonCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqEdiWorkOrderProcStateUpd = new ReqEdiWorkOrderProcStateUpd
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                RejectReasonCode = strRejectReasonCode,
                ProcType         = 9,
                AdminID          = objSes.AdminID
            };

            lo_objResEdiWorkOrderProcStateUpd = objOrderDasServices.SetEdiWorkOrderProcStateUpd(lo_objReqEdiWorkOrderProcStateUpd);
            objResMap.RetCode                 = lo_objResEdiWorkOrderProcStateUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResEdiWorkOrderProcStateUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 업로드
    /// </summary>
    private void SetPODFileUpload()
    {
        string                        lo_strExtension                   = string.Empty;
        string                        lo_strFileName                    = string.Empty;
        string                        lo_strFileNameNew                 = string.Empty;
        string                        lo_strFilePath                    = string.Empty;
        string                        lo_strFileDirOrder                = string.Empty;
        string                        lo_strFileUrlOrder                = string.Empty;
        string                        lo_strFileDirPOD                  = string.Empty;
        string                        lo_strFileUrlPOD                  = string.Empty;
        Random                        lo_rnd                            = new Random();
        DirectoryInfo                 lo_di                             = null;
        HttpPostedFile                lo_objHttpPostedFile              = null;
        OrderFileModel                lo_objOrderFileModel              = null;
        ServiceResult<OrderFileModel> lo_objResOrderFileIns             = null;
        ReqEdiWorkOrderProcStateUpd   lo_objReqEdiWorkOrderProcStateUpd = null;
        ServiceResult<bool>           lo_objResEdiWorkOrderProcStateUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strWorkOrderNumber))
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //1개 파일업로드만 허용
        if (!objRequest.Files.Count.Equals(1))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "하나의 파일만 첨부할 수 있습니다.";
            return;
        }

        try
        {
            lo_objHttpPostedFile = objRequest.Files[0];

            if (lo_objHttpPostedFile == null)
            {
                objResMap.RetCode = 9201;
                objResMap.ErrMsg  = "첨부된 파일이 없습니다.";
                return;
            }

            // 파일 업로드
            lo_strExtension    = Path.GetExtension(lo_objHttpPostedFile.FileName).ToLower().Replace(".", "");
            lo_strFileName     = Path.GetFileName(lo_objHttpPostedFile.FileName).ToLower();
            lo_strFileNameNew  = $"O{DateTime.Now.ToString("yyyyMMddHHmmss")}{lo_rnd.Next(1000, 10000)}.{lo_strExtension}";
            lo_strFileDirOrder = $"{SiteGlobal.FILE_SERVER_ROOT}\\ORDER\\{strCenterCode}\\{strOrderNo.Substring(0,                                  6)}\\{strOrderNo.Substring(6, 2)}\\{strOrderNo}\\";
            lo_strFileUrlOrder = $"/ORDER/{strCenterCode}/{strOrderNo.Substring(0,                                                                  6)}/{strOrderNo.Substring(6,  2)}/{strOrderNo}";
            lo_strFileDirPOD   = $"{SiteGlobal.FILE_SERVER_ROOT}\\POD\\{strCenterCode}\\{strWorkOrderNumber}\\";
            lo_strFileUrlPOD   = $"/POD/{strCenterCode}/{strWorkOrderNumber}/{lo_strFileNameNew}";

            lo_di = new DirectoryInfo(lo_strFileDirOrder);
            if (!lo_di.Exists)
            {
                lo_di.Create();
            }

            lo_di = new DirectoryInfo(lo_strFileDirPOD);
            if (!lo_di.Exists)
            {
                lo_di.Create();
            }

            if (lo_objHttpPostedFile.ContentLength.Equals(0))
            {
                objResMap.RetCode = 9001;
                objResMap.ErrMsg = "첨부된 파일이 없습니다.";
                return;
            }

            if (lo_objHttpPostedFile.ContentLength > 1024 * 1024 * 1)
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg = "첨부파일 용량은 1MB 이내로 등록가능합니다.";
                return;
            }

            if (!lo_strExtension.Equals("jpg") &&
                !lo_strExtension.Equals("jpeg") &&
                !lo_strExtension.Equals("png") &&
                !lo_strExtension.Equals("gif") &&
                !lo_strExtension.Equals("pdf"))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg = "첨부할 수 없는 파일확장자입니다.";
                return;
            }

            lo_strFilePath = Path.Combine(lo_strFileDirOrder, lo_strFileNameNew);

            if (File.Exists(lo_strFilePath))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg = "동일한 파일이 존재합니다.";
                return;
            }

            lo_objHttpPostedFile.SaveAs(lo_strFilePath);

            if (!File.Exists(lo_strFilePath))
            {
                objResMap.RetCode = 9006;
                objResMap.ErrMsg = "파일 업로드에 실패했습니다.";
                return;
            }

            lo_strFilePath = Path.Combine(lo_strFileDirPOD, lo_strFileNameNew);

            if (File.Exists(lo_strFilePath))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "동일한 파일이 존재합니다.";
                return;
            }

            lo_objHttpPostedFile.SaveAs(lo_strFilePath);

            if (!File.Exists(lo_strFilePath))
            {
                objResMap.RetCode = 9006;
                objResMap.ErrMsg  = "파일 업로드에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }

        try
        {
            lo_objOrderFileModel = new OrderFileModel
            {
                CenterCode  = strCenterCode.ToInt(),
                OrderNo     = strOrderNo.ToInt64(),
                FileRegType = 1,
                FileName    = lo_strFileName,
                FileNameNew = lo_strFileNameNew,
                FileDir     = lo_strFileUrlOrder,
                RegAdminID  = objSes.AdminID
            };

            lo_objResOrderFileIns = objOrderDasServices.SetOrderFileIns(lo_objOrderFileModel);
            objResMap.RetCode     = lo_objResOrderFileIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderFileIns.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
        }

        try
        {
            lo_objReqEdiWorkOrderProcStateUpd = new ReqEdiWorkOrderProcStateUpd
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNo    = strOrderNo.ToInt64(),
                PODUrl     = SiteGlobal.FILE_DOMAIN + lo_strFileUrlPOD,
                ProcType   = 8,
                AdminID    = objSes.AdminID
            };

            lo_objResEdiWorkOrderProcStateUpd = objOrderDasServices.SetEdiWorkOrderProcStateUpd(lo_objReqEdiWorkOrderProcStateUpd);
            objResMap.RetCode                 = lo_objResEdiWorkOrderProcStateUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResEdiWorkOrderProcStateUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutEIHandler", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, objResMap.RetCode);
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