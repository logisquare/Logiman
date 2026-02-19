<%@ WebHandler Language="C#" Class="InoutPdfDropFileHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.IO;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using System.Collections.Generic;
using Spire.Pdf;

///================================================================
/// <summary>
/// FileName        : InoutPdfDropFileHandler.ashx
/// Description     : 수출입 오더 파일 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2024-01-19
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutPdfDropFileHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Inout/InoutIns"; //필수

    // 메소드 리스트
    private const string MethodPdfOrderFileDrop = "PdfOrderFileDrop";
    private const string MethodPlaceChargeList  = "PlaceChargeList";

    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    OrderDasServices             objOrderDasServices             = new OrderDasServices();

    private string strCallType      = string.Empty;
    private string strCenterCode    = string.Empty;
    private string strOrderNo       = string.Empty;
    private string strOrderItemCode = string.Empty; //상품코드 0A001 : 항공수출, OA002 : 항공수입
    private string strFileSeqNo     = string.Empty;
    private string strFileNameNew   = string.Empty;
    private string strFileName      = string.Empty;
    private string strTempFlag      = string.Empty;
    private string strFileRegType   = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPdfOrderFileDrop, MenuAuthType.All);
        objMethodAuthList.Add(MethodPlaceChargeList,  MenuAuthType.All);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);

        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType     = SiteGlobal.GetRequestForm("CallType");

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

            SiteGlobal.WriteLog("InoutPdfDropFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutPdfDropFileHandler");
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
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strOrderItemCode = SiteGlobal.GetRequestForm("OrderItemCode");
            strFileSeqNo     = Utils.IsNull(Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileSeqNo")), "0");
            strTempFlag      = SiteGlobal.GetRequestForm("TempFlag");
            strFileNameNew   = Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileNameNew"));
            strFileName      = SiteGlobal.GetRequestForm("FileName");
            strFileRegType   = Utils.IsNull(SiteGlobal.GetRequestForm("FileRegType"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutPdfDropFileHandler", "Exception",
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
                case MethodPdfOrderFileDrop:
                    SetPdfOrderFileDrop();
                    break;
                case MethodPlaceChargeList:
                    GetPlaceChargeList();
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

            SiteGlobal.WriteLog("InoutPdfDropFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    protected void GetPlaceChargeList()
    {
        ReqClientPlaceChargeList                lo_objReqClientPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList> lo_objResClientPlaceChargeList = null;
        int                                     lo_intSeqNo                    = 0;
        int                                     lo_intPlaceSeqNo               = 0;
        string                                  lo_strSetType                  = string.Empty;

        if (string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        switch (strOrderItemCode)
        {
            case "OA001": //항공수출 - 하차지 담당자 김종수
                switch (SiteGlobal.DOMAINNAME.ToLower())
                {
                    case CommonConstant.LOCALDEV_DOMAIN:
                    case CommonConstant.DEV_DOMAIN:
                        lo_intPlaceSeqNo = 14;
                        lo_intSeqNo      = 20;
                        break;
                    case CommonConstant.TEST_DOMAIN:
                    case CommonConstant.REAL_DOMAIN:
                        lo_intPlaceSeqNo = 1154;
                        lo_intSeqNo      = 7791;
                        break;
                }

                lo_strSetType = "Get";
                break;
            case "OA002": //항공수입 - 상차지 담당자 권오현
                switch (SiteGlobal.DOMAINNAME.ToLower())
                {
                    case CommonConstant.LOCALDEV_DOMAIN:
                    case CommonConstant.DEV_DOMAIN:
                        lo_intPlaceSeqNo = 14;
                        lo_intSeqNo      = 21;
                        break;
                    case CommonConstant.TEST_DOMAIN:
                        lo_intPlaceSeqNo = 1435;
                        lo_intSeqNo      = 47526;
                        break;
                    case CommonConstant.REAL_DOMAIN:
                        lo_intPlaceSeqNo = 979;
                        lo_intSeqNo      = 9003;
                        break;
                }

                lo_strSetType = "Pickup";
                break;
        }

        if (lo_intSeqNo.Equals(0))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeList = new ReqClientPlaceChargeList
            {
                PlaceSeqNo = lo_intPlaceSeqNo,
                SeqNo      = lo_intSeqNo
            };

            lo_objResClientPlaceChargeList = objClientPlaceChargeDasServices.GetClientPlaceChargeList(lo_objReqClientPlaceChargeList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + ",{\"SetType\":\"" + lo_strSetType + "\"}]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9200;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutPdfDropFileHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 업로드
    /// </summary>
    private void SetPdfOrderFileDrop()
    {
        string                          strRawData              = string.Empty;
        string                          lo_strExtension         = string.Empty;
        string                          lo_strFileName          = string.Empty;
        string                          lo_strFileNameNew       = string.Empty;
        string                          lo_strFileDir           = string.Empty;
        string                          lo_strFileUrl           = string.Empty;
        HttpFileCollection              files                   = objRequest.Files;
        Random                          lo_rnd                  = new Random();
        DirectoryInfo                   lo_di                   = null;
        HttpPostedFile                  lo_objHttpPostedFile    = null;
        InsOrder                        lo_OrderModel           = null;
        OrderPdfLogModel                lo_objReqOrderPdfLogIns = null;
        ServiceResult<OrderPdfLogModel> lo_objResOrderPdfLogIns = null;
        int                             lo_intRegType           = 0;

        //1개 파일업로드만 허용
        if (!objRequest.Files.Count.Equals(1))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "하나의 PDF만 첨부할 수 있습니다.";
            return;
        }

        try
        {
            lo_OrderModel = new InsOrder();

            foreach (string key in files)
            {
                lo_objHttpPostedFile = files[key];
                lo_strFileName       = lo_objHttpPostedFile.FileName;
                lo_strExtension      = Path.GetExtension(lo_objHttpPostedFile.FileName).ToLower().Replace(".", "");
                lo_strFileNameNew    = "O" + DateTime.Now.ToString("yyyyMMddHHmmss") + lo_rnd.Next(1000, 10000) + "." + lo_strExtension;
                lo_strFileDir        = SiteGlobal.FILE_SERVER_ROOT + @"\INOUT\DHL\" + DateTime.Now.Year + @"\" + DateTime.Now.ToString("MM") + @"\" ;
                lo_strFileUrl        = SiteGlobal.FILE_DOMAIN + "/INOUT/DHL/"  + DateTime.Now.Year + "/" + DateTime.Now.ToString("MM") + "/" + lo_strFileNameNew;
                lo_di                = new DirectoryInfo(lo_strFileDir);

                if (!lo_di.Exists)
                {
                    lo_di.Create();
                }

                if (lo_objHttpPostedFile.ContentLength.Equals(0))
                {
                    objResMap.RetCode = 9001;
                    objResMap.ErrMsg  = "첨부된 파일이 없습니다.";
                    return;
                }

                if (!lo_strExtension.Equals("pdf"))
                {
                    objResMap.RetCode = 9003;
                    objResMap.ErrMsg  = "첨부할 수 없는 파일확장자입니다.";
                    return;
                }

                lo_objHttpPostedFile.SaveAs(lo_strFileDir + lo_strFileNameNew);

                if (!File.Exists(lo_strFileDir + lo_strFileNameNew))
                {
                    objResMap.RetCode = 9006;
                    objResMap.ErrMsg  = "파일 업로드에 실패했습니다.";
                    return;
                }

                strRawData = GetPDFRawData(lo_strFileDir + lo_strFileNameNew);

                if (!string.IsNullOrWhiteSpace(strRawData))
                {
                    switch (strOrderItemCode)
                    {
                        case "OA001": //항공수출
                            ParseDHLOut(strRawData, lo_OrderModel);
                            lo_intRegType = 1;
                            break;
                        case "OA002": //항공수입
                            ParseDHLIn(strRawData, lo_OrderModel);
                            lo_intRegType = 2;
                            break;
                    }

                    try
                    {
                        lo_objReqOrderPdfLogIns = new OrderPdfLogModel
                        {
                            FileName     = lo_strFileName,
                            FileUrl      = lo_strFileUrl,
                            RawData      = strRawData,
                            ViewData     = lo_OrderModel.NoteInside,
                            RegType      = lo_intRegType, //등록구분(1: DHL항공수출, 2: DHL항공수입)
                            RegAdminID   = objSes.AdminID,
                            RegAdminName = objSes.AdminName
                        };

                        lo_objResOrderPdfLogIns = objOrderDasServices.SetOrderPdfLogIns(lo_objReqOrderPdfLogIns);
                    }
                    catch (Exception)
                    {
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(strRawData))
            {
                objResMap.RetCode = 9999;
                objResMap.ErrMsg  = "PDF 본문 추출 실패";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = lo_ex.ToString();

            SiteGlobal.WriteLog(
                "InoutPdfDropFileHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }

    /// <summary>
    ///  PDF RawData 생성
    /// </summary>
    /// <param name="pdfPath"></param>
    /// <returns></returns>
    private string GetPDFRawData(string pdfPath)
    {
        string strResult = string.Empty;

        try
        {
            //create a pdf document
            PdfDocument doc = new PdfDocument();
            doc.LoadFromFile(pdfPath);

            StringBuilder buffer = new StringBuilder();
            foreach (PdfPageBase page in doc.Pages)
            {
                buffer.Append(page.ExtractText());
            }

            doc.Close();

            strResult = buffer.ToString();
        }
        catch
        {
            strResult = string.Empty;
        }

        if (!string.IsNullOrWhiteSpace(strResult))
        {
            strResult = strResult.Replace("\n", "\r\n");
        }

        return strResult;
    }

    /// <summary>
    ///  DHL 항공수입 파싱
    /// </summary>
    /// <param name="strOrgRawData"></param>
    /// <param name="order"></param>
    protected void ParseDHLIn(string strOrgRawData, InsOrder order)
    {
        order.NoteInside = string.Empty;

        int            i, j, k;
        string         strDateMode     = string.Empty;
        string         strRawData      = strOrgRawData;
        string         strValue        = string.Empty;
        int            nStartPos       = 0;
        Double         dblNumber       = 0;
        bool           bIsGoods        = false;
        string         strGoods        = string.Empty;
        bool           bGetAddrEndFlag = false;
        bool           bIsInch         = false;
        DateTime       dtDate;
        string[]       arrGoods;
        string[]       arrTmp;
        string[]       arrTmp1;
        string[]       arrTmp2;
        string[]       arrTmp3;
        ReqContactInfo lo_objReqContactInfo = null;
        ResContactInfo lo_objResContactInfo = null;

        try
        {
            nStartPos = strRawData.IndexOf("Delivery Order", StringComparison.Ordinal);

            if (nStartPos < 0)
            {
                objResMap.RetCode = 9999;
                objResMap.ErrMsg  = "문서 형식이 올바르지 않습니다.";
                return;
            }

            strRawData = strRawData.Substring(nStartPos);
            string[] arrRawData = strRawData.Split(new string[] { "\r\n" }, StringSplitOptions.None);

            for (i = 0; i < arrRawData.Length; i++)
            {
                arrRawData[i] = arrRawData[i].TrimStart().Replace("\r", "").Replace("\n", "");
            }

            // 화주명
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("CONSIGNEE", StringComparison.Ordinal);
                if (nStartPos >= 0)
                {
                    arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                    if (arrTmp.Length >= 2)
                    {
                        order.ConsignorName = arrTmp[1].TrimEnd();
                    }
                    break;
                }
            }

            // H/AWB
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("HAWB", StringComparison.Ordinal);
                if (nStartPos >= 0)
                {
                    arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                    if (arrTmp.Length >= 1)
                    {
                        order.Hawb = arrTmp[arrTmp.Length - 1].TrimEnd();
                    }
                    break;
                }
                else
                {
                    nStartPos = arrRawData[i].IndexOf("HOUSE BILL", StringComparison.Ordinal);
                    if (nStartPos >= 0)
                    {
                        arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                        if (arrTmp.Length >= 1)
                        {
                            order.Hawb = arrTmp[arrTmp.Length - 1].TrimEnd();
                        }
                        break;
                    }
                }
            }

            // 수량/무게/CBM
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("TOTAL:", StringComparison.Ordinal);

                if (nStartPos >= 0)
                {
                    arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i].Substring(nStartPos + ("TOTAL:".Length)).TrimStart(), @"\s{2,}");
                    if (arrTmp.Length >= 3)
                    {
                        order.Volume = arrTmp[0].Split(' ')[0].ToInt();
                        order.Weight = Math.Round(arrTmp[1].Split(' ')[0].ToDouble(), 1);
                        order.CBM    = Math.Round(arrTmp[2].Split(' ')[0].ToDouble(), 2);
                    }
                    break;
                }
            }

            // 세부 화물정보 - 가로x세로x높이x수량
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (!bIsGoods)
                {
                    if (arrRawData[i].IndexOf("PACKAGE DETAILS", StringComparison.Ordinal) >= 0)
                    {
                        bIsGoods = true;
                    }
                }
                else
                {
                    if (arrRawData[i].IndexOf("TOTAL:", StringComparison.Ordinal) >= 0)
                    {
                        break;
                    }

                    arrGoods = arrRawData[i].Split(' ');

                    if (arrGoods.Length < 5)
                    {
                        continue;
                    }

                    if (arrRawData[i].IndexOf("PCE", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("BLC", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("PLT", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("KG", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("CM", StringComparison.Ordinal) < 0)
                    {
                        continue;
                    }
                    
                    arrTmp   = arrRawData[i].Split(' ');
                    bIsInch  = arrTmp.Length >= 2 && (arrTmp[arrTmp.Length-1].Equals("IN") || arrTmp[arrTmp.Length - 2].Equals("IN"));
                    strGoods = string.Empty;

                    for (j = 0; j < arrGoods.Length; j++)
                    {
                        if (Double.TryParse(arrGoods[j], out dblNumber))
                        {
                            strGoods += (!string.IsNullOrWhiteSpace(strGoods) ? "," : "") + dblNumber;
                        }
                    }

                    if (strGoods.Split(',').Length >= 6)
                    {
                        InsOrderGoods lo_objGoods = new InsOrderGoods
                        {
                            Volume = strGoods.Split(',')[0].ToInt(),
                            Length = strGoods.Split(',')[3].ToDouble(),
                            Width  = strGoods.Split(',')[4].ToDouble(),
                            Height = strGoods.Split(',')[5].ToDouble()
                        };

                        if (bIsInch) // INCH 인 경우, CM로 변환
                        {
                            lo_objGoods.Length = Math.Round(lo_objGoods.Length * 2.54);
                            lo_objGoods.Width  = Math.Round(lo_objGoods.Width * 2.54);
                            lo_objGoods.Height = Math.Round(lo_objGoods.Height * 2.54);
                        }

                        order.goods.Add(lo_objGoods);
                    }
                }
            }

            // 비고-내부
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (arrRawData[i].StartsWith("운송 요청 사항"))
                {
                    for (j = i + 1; j < arrRawData.Length; j++)
                    {
                        if (arrRawData[j].StartsWith("배송지 정보"))
                        {
                            break;
                        }

                        if (!string.IsNullOrWhiteSpace(order.NoteInside))
                        {
                            order.NoteInside += "\r\n";
                        }

                        order.NoteInside += arrRawData[j];
                    }

                    break;
                }
            }

            // 상하차지주소
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (!arrRawData[i].StartsWith("배송지 정보"))
                {
                    continue;
                }

                for (k = i+1; k < arrRawData.Length; k++)
                {
                    if (arrRawData[k].IndexOf("Planned", StringComparison.Ordinal) >= 0)
                    {
                        string strBuff = string.Empty;
                        string[] arrBuff = arrRawData[k + 1].Split(new string[] { "Required To: " }, StringSplitOptions.None);
                        if (arrBuff.Length > 1)
                        {
                            strBuff = arrBuff[arrBuff.Length-1];
                        }

                        if (strBuff.Length >= 3)
                        {

                            dtDate = DateTime.ParseExact(strBuff.Replace("\r", ""), "yy-M-dd HH:mm", System.Globalization.CultureInfo.InvariantCulture);

                            if (strDateMode.Equals("PICKUP"))
                            {
                                order.PickupYMD = dtDate.ToString("yyyyMMdd");
                                order.PickupHM  = dtDate.ToString("HHmm");
                            }
                            else if (strDateMode.Equals("GET"))
                            {
                                order.GetYMD    = dtDate.ToString("yyyyMMdd");
                                order.GetHM     = dtDate.ToString("HHmm");
                                bGetAddrEndFlag = true;
                            }
                        }
                        else
                        {
                            if (strDateMode.Equals("PICKUP"))
                            {
                                order.PickupYMD = string.Empty;
                                order.PickupHM  = string.Empty;
                            }
                            else if (strDateMode.Equals("GET"))
                            {
                                order.GetYMD    = string.Empty;
                                order.GetHM     = string.Empty;
                            }
                        }
                    }
                    else
                    {
                        if (strDateMode.Equals("GET"))
                        {
                            if (bGetAddrEndFlag.Equals(false))
                            {
                                if (!arrRawData[k].Contains("Drop:"))
                                {
                                    continue;
                                }

                                arrTmp1 = System.Text.RegularExpressions.Regex.Split(arrRawData[k], @"Drop:");
                                if (string.IsNullOrWhiteSpace(arrTmp1[0].TrimEnd()))
                                {
                                    continue;
                                }

                                arrTmp2 = System.Text.RegularExpressions.Regex.Split(arrTmp1[0], @"담당자:");
                                if (arrTmp2.Length >= 2)
                                {
                                    arrTmp3 = System.Text.RegularExpressions.Regex.Split(arrTmp2[1].TrimStart(), @"\+82");
                                    if (arrTmp3.Length >= 2)
                                    {
                                        order.GetPlaceChargeName = arrTmp3[0].Replace(" ","");
                                        order.GetPlaceChargeTelNo = "0" + arrTmp3[1].Replace(" ", "");
                                    }
                                }

                                if (!string.IsNullOrWhiteSpace(order.GetPlaceAddr))
                                {
                                    order.GetPlaceAddr += " ";
                                }

                                order.GetPlaceAddr += arrTmp2[0].TrimEnd();
                            }
                        }
                    }

                    if (arrRawData[k].IndexOf("2  배송지", StringComparison.Ordinal) >= 0 || arrRawData[k].IndexOf("2  운송", StringComparison.Ordinal) >= 0)
                    {
                        strDateMode = "GET";

                        nStartPos = arrRawData[k].IndexOf("2  배송지", StringComparison.Ordinal);
                        if(nStartPos >= 0)
                        {
                            order.GetPlace = arrRawData[k].Substring(nStartPos + "2  배송지".Length).Trim();
                        }

                        nStartPos = arrRawData[k].IndexOf("2  운송", StringComparison.Ordinal);
                        if (nStartPos >= 0)
                        {
                            order.GetPlace = arrRawData[k].Substring(nStartPos + "2  운송".Length).Trim();
                        }
                    }
                }

                break;
            }

            //주소 파싱
            if (!string.IsNullOrWhiteSpace(order.GetPlaceAddr))
            {
                lo_objReqContactInfo = new ReqContactInfo
                {
                    in_str    = order.GetPlaceAddr,
                    force_map = "Y",
                    map_cache = "Y"
                };

                lo_objResContactInfo = SiteGlobal.GetContactInfo(lo_objReqContactInfo);

                if (lo_objResContactInfo.ResultCode.IsSuccess())
                {
                    if (lo_objResContactInfo.ResultBody.Address != null)
                    {
                        if (lo_objResContactInfo.ResultBody.Address.OutAddress != null)
                        {
                            order.APIPlaceFlag      = "Y";
                            order.APIPlacePost      = lo_objResContactInfo.ResultBody.Address.OutAddress.ZipCode;
                            order.APIPlaceAddr      = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressMain;
                            order.APIPlaceAddrDtl   = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressDetail;
                            order.APIPlaceFullAddr  = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressDong;
                            order.APIPlaceLocalCode = lo_objResContactInfo.ResultBody.Address.OutAddress.RegionCode;
                            order.APIPlaceLocalName = lo_objResContactInfo.ResultBody.Address.OutAddress.RegionName;

                            if (lo_objResContactInfo.ResultBody.Manager != null && lo_objResContactInfo.ResultBody.Manager.Count > 0)
                            {
                                order.APIPlaceChargeFlag     = "Y";
                                order.APIPlaceChargeName     = lo_objResContactInfo.ResultBody.Manager[0].Name;
                                order.APIPlaceChargeTelNo    = lo_objResContactInfo.ResultBody.Manager[0].Office;
                                order.APIPlaceChargeTelExtNo = lo_objResContactInfo.ResultBody.Manager[0].Ext;
                                order.APIPlaceChargeCell     = lo_objResContactInfo.ResultBody.Manager[0].Mobile;
                                order.APIPlaceChargePosition = lo_objResContactInfo.ResultBody.Manager[0].Sir;
                            }
                        }
                    }
                }
                else
                {
                    SiteGlobal.WriteLog(
                        "InoutPdfDropFileHandler",
                        "Exception",
                        "\r\n\t[ex.Message] : ("+lo_objResContactInfo.ResultCode+")" + lo_objResContactInfo.ResultMessage,
                        9992);
                }
            }

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(order) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9992;
            objResMap.ErrMsg = $"Exception 발생({lo_ex.Message})";

            SiteGlobal.WriteLog(
                                "InoutPdfDropFileHandler",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9992);
        }
    }

    /// <summary>
    ///  DHL 항공수출 파싱
    /// </summary>
    /// <param name="pdfPath"></param>
    /// <returns></returns>
    protected void ParseDHLOut(string strOrgRawData, InsOrder order)
    {
        order.NoteInside = string.Empty;

        int                  i, j, k;
        string               strDateMode = string.Empty;
        DateTime             dtDate;
        string               strRawData           = strOrgRawData;
        string               strValue             = string.Empty;
        int                  nStartPos            = 0;
        List<NationCodeInfo> nation               = new List<NationCodeInfo>();
        ReqContactInfo       lo_objReqContactInfo = null;
        ResContactInfo       lo_objResContactInfo = null;

        try
        {
            nStartPos = strRawData.IndexOf("Cartage Advice", StringComparison.Ordinal);

            if (nStartPos < 0)
            {
                objResMap.RetCode    = 9999;
                objResMap.ErrMsg = "문서 형식이 올바르지 않습니다.";
                return;
            }

            strRawData = strRawData.Substring(nStartPos);
            string[] arrRawData = strRawData.Split(new string[] { "\r\n" }, StringSplitOptions.None);

            for (i = 0; i < arrRawData.Length; i++)
            {
                arrRawData[i] = arrRawData[i].TrimStart().Replace("\r","").Replace("\n","");
            }

            // M/AWB
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (arrRawData[i].StartsWith("SHIPMENT"))
                {
                    string[] arrTmp = arrRawData[i].Split(' ');
                    if(arrTmp.Length >= 2)
                    {
                        order.Mawb = arrTmp[1].Trim();
                    }
                    break;
                }
            }

            // 화주명
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("SHIPPER", StringComparison.Ordinal);
                if (nStartPos >= 0)
                {
                    string[] arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i+1], @"\s{3,}");
                    if (arrTmp.Length >= 2)
                    {
                        order.ConsignorName = arrTmp[0].TrimEnd();
                    }
                    break;
                }
            }

            LoadNationCode(ref nation);

            // 목적국
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("SHIPMENT DESTINATION", StringComparison.Ordinal);
                if (nStartPos >= 0)
                {
                    string[] arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                    if (arrTmp.Length >= 2)
                    {
                        order.Nation = arrTmp[0].TrimEnd();
                        for(j = 0; j < nation.Count; j++)
                        {
                            if (nation[j].NationCode.Equals(order.Nation.Substring(0, 2)))
                            {
                                order.Nation = nation[j].KoreaName;
                                break;
                            }
                        }
                    }
                    break;
                }
            }

            // H/AWB
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("HAWB", StringComparison.Ordinal);
                if (nStartPos >= 0)
                {
                    string[] arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                    if (arrTmp.Length >= 1)
                    {
                        order.Hawb = arrTmp[arrTmp.Length - 1].TrimEnd();
                    }
                    break;
                }
                else
                {
                    nStartPos = arrRawData[i].IndexOf("HOUSE BILL", StringComparison.Ordinal);
                    if (nStartPos >= 0)
                    {
                        string[] arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i + 1], @"\s{3,}");
                        if (arrTmp.Length >= 1)
                        {
                            order.Hawb = arrTmp[arrTmp.Length - 1].TrimEnd();
                        }
                        break;
                    }
                }
            }

            // 수량/무게/CBM
            for (i = 0; i < arrRawData.Length; i++)
            {
                nStartPos = arrRawData[i].IndexOf("TOTAL:", StringComparison.Ordinal);

                if (nStartPos >= 0)
                {
                    string[] arrTmp = System.Text.RegularExpressions.Regex.Split(arrRawData[i].Substring(nStartPos+ ("TOTAL:".Length)).TrimStart(), @"\s{2,}");
                    if (arrTmp.Length >= 3)
                    {
                        order.Volume = arrTmp[0].Split(' ')[0].ToInt();
                        order.Weight = Math.Ceiling(arrTmp[1].Split(' ')[0].ToDouble());    // 소수점 올림
                        order.CBM    = Math.Round(arrTmp[2].Split(' ')[0].ToDouble(),2);    // 소수점2자리 반올림
                    }
                    break;
                }
            }

            string[] arrGoods;
            Double   dblNumber = 0;
            bool     bIsGoods  = false;
            string   strGoods  = string.Empty;

            // 세부 화물정보 - 가로x세로x높이x수량
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (!bIsGoods)
                {
                    if (arrRawData[i].IndexOf("PACKAGES DETAILS", StringComparison.Ordinal) >= 0)
                    {
                        bIsGoods = true;
                    }
                }
                else
                {
                    if (arrRawData[i].IndexOf("TOTAL:", StringComparison.Ordinal) >= 0)
                    {
                        break;
                    }

                    arrGoods = arrRawData[i].Split(' ');

                    if (arrGoods.Length < 5)
                    {
                        continue;
                    }

                    if (arrRawData[i].IndexOf("PCE", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("BLC", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("PLT", StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("KG",  StringComparison.Ordinal) < 0 &&
                        arrRawData[i].IndexOf("CM",  StringComparison.Ordinal) < 0)
                    {
                        continue;
                    }

                    strGoods = string.Empty;

                    for(j = 0; j < arrGoods.Length; j++)
                    {
                        if (Double.TryParse(arrGoods[j], out dblNumber))
                        {
                            if (!string.IsNullOrWhiteSpace(strGoods))
                            {
                                strGoods += ",";
                            }

                            strGoods += dblNumber;
                        }
                    }

                    if (strGoods.Split(',').Length >= 6)
                    {
                        InsOrderGoods lo_objGoods = new InsOrderGoods
                        {
                            Volume = strGoods.Split(',')[0].ToInt(),
                            Length = strGoods.Split(',')[3].ToDouble(),
                            Width  = strGoods.Split(',')[4].ToDouble(),
                            Height = strGoods.Split(',')[5].ToDouble()
                        };

                        order.goods.Add(lo_objGoods);
                    }
                }
            }

            // 비고-내부
            for (i = 0; i < arrRawData.Length; i++)
            {
                if (arrRawData[i].StartsWith("HANDLING/CARTAGE INSTRUCTIONS"))
                {
                    for (j = i + 1; j < arrRawData.Length; j++)
                    {
                        if (arrRawData[j].StartsWith("INSTRUCTIONS DETAILS"))
                        {
                            break;
                        }

                        if (!string.IsNullOrWhiteSpace(order.NoteInside))
                        {
                            order.NoteInside += "\r\n";
                        }

                        order.NoteInside += arrRawData[j];
                    }

                    for (k = j; k < arrRawData.Length; k++)
                    {
                        if (arrRawData[k].IndexOf("PICKUP", StringComparison.Ordinal) >=0)
                        {
                            strDateMode = "PICKUP";
                        }
                        if (arrRawData[k].IndexOf("DELIVERY", StringComparison.Ordinal) >= 0)
                        {
                            strDateMode = "GET";
                        }

                        if (arrRawData[k].IndexOf("Planned", StringComparison.Ordinal) >= 0)
                        {
                            string[] arrDate = System.Text.RegularExpressions.Regex.Split(arrRawData[k+1], @"\s{3,}");

                            if (arrDate.Length < 3)
                            {
                                arrDate = System.Text.RegularExpressions.Regex.Split(arrRawData[k + 2], @"\s{3,}");
                            }

                            if (arrDate.Length >= 3)
                            {
                                string[] arrDateTmp;

                                string[] arrBuff = arrDate[2].Split(new string[] { "Required To: " }, StringSplitOptions.None);
                                if (arrBuff.Length > 1)
                                {
                                    arrDateTmp = arrBuff[arrBuff.Length - 1].Split(' ');
                                }
                                else
                                {
                                    arrDateTmp = arrDate[2].Replace("Required From: ", "").Split(' ');
                                }

                                if (arrDateTmp.Length >= 2)
                                {
                                    dtDate = DateTime.ParseExact((arrDateTmp[0] + " " + arrDateTmp[1]).Replace("\r", ""), "dd-MMM-yy HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                                }
                                else
                                {
                                    continue;
                                }

                                if (strDateMode.Equals("PICKUP"))
                                {
                                    order.PickupYMD = dtDate.ToString("yyyyMMdd");
                                    order.PickupHM  = dtDate.ToString("HHmm");
                                }
                                else if (strDateMode.Equals("GET"))
                                {
                                    order.GetYMD = dtDate.ToString("yyyyMMdd");
                                    order.GetHM  = dtDate.ToString("HHmm");
                                }

                            }
                            else
                            {
                                if (strDateMode.Equals("PICKUP"))
                                {
                                    order.PickupYMD = string.Empty;
                                    order.PickupHM  = string.Empty;
                                }
                                else if (strDateMode.Equals("GET"))
                                {
                                    order.GetYMD = string.Empty;
                                    order.GetHM  = string.Empty;
                                }
                            }
                        }
                    }

                    break;
                }
            }

            //주소 파싱
            if (!string.IsNullOrWhiteSpace(order.NoteInside))
            {
                lo_objReqContactInfo = new ReqContactInfo
                {
                    in_str = order.NoteInside,
                    force_map = "Y",
                    map_cache = "Y"
                };

                lo_objResContactInfo = SiteGlobal.GetContactInfo(lo_objReqContactInfo);

                if (lo_objResContactInfo.ResultCode.IsSuccess())
                {
                    if (lo_objResContactInfo.ResultBody.Address != null)
                    {
                        if (lo_objResContactInfo.ResultBody.Address.OutAddress != null)
                        {
                            order.APIPlaceFlag      = "Y";
                            order.APIPlacePost      = lo_objResContactInfo.ResultBody.Address.OutAddress.ZipCode;
                            order.APIPlaceAddr      = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressMain;
                            order.APIPlaceAddrDtl   = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressDetail;
                            order.APIPlaceFullAddr  = lo_objResContactInfo.ResultBody.Address.OutAddress.AddressDong;
                            order.APIPlaceLocalCode = lo_objResContactInfo.ResultBody.Address.OutAddress.RegionCode;
                            order.APIPlaceLocalName = lo_objResContactInfo.ResultBody.Address.OutAddress.RegionName;

                            if (lo_objResContactInfo.ResultBody.Manager != null && lo_objResContactInfo.ResultBody.Manager.Count > 0)
                            {
                                order.APIPlaceChargeFlag     = "Y";
                                order.APIPlaceChargeName     = lo_objResContactInfo.ResultBody.Manager[0].Name;
                                order.APIPlaceChargeTelNo    = lo_objResContactInfo.ResultBody.Manager[0].Office;
                                order.APIPlaceChargeTelExtNo = lo_objResContactInfo.ResultBody.Manager[0].Ext;
                                order.APIPlaceChargeCell     = lo_objResContactInfo.ResultBody.Manager[0].Mobile;
                                order.APIPlaceChargePosition = lo_objResContactInfo.ResultBody.Manager[0].Sir;
                            }
                        }
                    }
                }
                else
                {
                    SiteGlobal.WriteLog(
                        "InoutPdfDropFileHandler",
                        "Exception",
                        "\r\n\t[ex.Message] : ("+lo_objResContactInfo.ResultCode+")" + lo_objResContactInfo.ResultMessage,
                        9992);
                }
            }

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(order) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9992;
            objResMap.ErrMsg = $"Exception 발생({lo_ex.Message})";

            SiteGlobal.WriteLog(
                                "InoutPdfDropFileHandler",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9992);
        }
    }

    public class NationCodeInfo
    {
        public string EngName    { get;  set; }
        public string KoreaName  {  get; set; }
        public string NationCode {  get; set; }
    }

    public class InsOrderGoods
    {
        public double Length { get; set; } // 길이 (가로)
        public double Width  { get; set; } // 폭   (세로)
        public double Height { get; set; } // 높이 (높이)
        public int    Volume { get; set; } // 수량 (수량)
    }

    public class InsOrder
    {
        public int    RetCode                { get; set; }
        public string ErrMsg                 { get; set; }
        public string Mawb                   { get; set; }        // Mawb
        public string Hawb                   { get; set; }        // Hawb
        public string ConsignorName          { get; set; }        // 화주명
        public string Nation                 { get; set; }        // 목적국
        public int    Volume                 { get; set; }        // 수량
        public double Weight                 { get; set; }        // 중량
        public double CBM                    { get; set; }        // CBM
        public double Length                 { get; set; }        // 길이
        public double Width                  { get; set; }        // 폭
        public double Height                 { get; set; }        // 높이
        public string NoteInside             { get; set; }        // 비고-내부
        public string Quantity               { get; set; }        // 대량화물
        public string PickupYMD              { get; set; }        // 상차일
        public string PickupHM               { get; set; }        // 상차시간
        public string PickupPlace            { get; set; }        // 상차지명
        public string PickupPlacePost        { get; set; }        // 상차지 우편번호
        public string PickupPlaceAddr        { get; set; }        // 상차지 주소
        public string PickupPlaceAddrDtl     { get; set; }        // 상차지 주소상세
        public string PickupPlaceChargeName  { get; set; }        // 상차지 담당자
        public string GetYMD                 { get; set; }        // 하차일
        public string GetHM                  { get; set; }        // 하차시간
        public string GetPlace               { get; set; }        // 하차지명
        public string GetPlacePost           { get; set; }        // 하차지 우편번호
        public string GetPlaceAddr           { get; set; }        // 하차지 주소
        public string GetPlaceAddrDtl        { get; set; }        // 하차지 주소상세
        public string GetPlaceChargeName     { get; set; }        // 하차지 담당자
        public string GetPlaceChargeTelNo    { get; set; }        // 하차지 담당자 연락처
        public string APIPlaceFlag           { get; set; } = "N"; // API 주소 조회여부
        public string APIPlacePost           { get; set; }        // API 주소 우편번호
        public string APIPlaceAddr           { get; set; }        // API 주소 주소
        public string APIPlaceAddrDtl        { get; set; }        // API 주소 주소상세
        public string APIPlaceFullAddr       { get; set; }        // API 주소 적용주소
        public string APIPlaceChargeFlag     { get; set; } = "N"; // API 주소 조회여부
        public string APIPlaceChargeName     { get; set; }        // API 주소 담당자
        public string APIPlaceChargeTelNo    { get; set; }        // API 주소 담당자 연락처
        public string APIPlaceChargeTelExtNo { get; set; }        // API 주소 담당자 연락처 내선번호
        public string APIPlaceChargeCell     { get; set; }        // API 주소 담당자 휴대폰번호
        public string APIPlaceChargePosition { get; set; }        // API 주소 담당자 직급
        public string APIPlaceLocalCode      { get; set; }        // API 주소 지역코드
        public string APIPlaceLocalName      { get; set; }        // API 주소 지역명

        public List<InsOrderGoods> goods = new List<InsOrderGoods>();
    }

    public static void LoadNationCode(ref List<NationCodeInfo> nation)
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine("[{\"EngName\":\"Taiwan\",\"KoreaName\":\"대만\",\"NationCode\":\"TW\"},");
        sb.AppendLine("{\"EngName\":\"Afghanistan\",\"KoreaName\":\"아프가니스탄\",\"NationCode\":\"AF\"},");
        sb.AppendLine("{\"EngName\":\"Albania\",\"KoreaName\":\"알바니아\",\"NationCode\":\"AL\"},");
        sb.AppendLine("{\"EngName\":\"Algeria\",\"KoreaName\":\"알제리\",\"NationCode\":\"DZ\"},");
        sb.AppendLine("{\"EngName\":\"American Samoa\",\"KoreaName\":\"아메리칸사모아\",\"NationCode\":\"AS\"},");
        sb.AppendLine("{\"EngName\":\"Andorra\",\"KoreaName\":\"안도라\",\"NationCode\":\"AD\"},");
        sb.AppendLine("{\"EngName\":\"Angola\",\"KoreaName\":\"앙골라\",\"NationCode\":\"AO\"},");
        sb.AppendLine("{\"EngName\":\"Anguilla\",\"KoreaName\":\"앵귈라\",\"NationCode\":\"AI\"},");
        sb.AppendLine("{\"EngName\":\"Antarctica\",\"KoreaName\":\"남극\",\"NationCode\":\"AQ\"},");
        sb.AppendLine("{\"EngName\":\"Antigua & Barbuda\",\"KoreaName\":\"앤티가 바부다\",\"NationCode\":\"AG\"},");
        sb.AppendLine("{\"EngName\":\"Argentina\",\"KoreaName\":\"아르헨티나\",\"NationCode\":\"AR\"},");
        sb.AppendLine("{\"EngName\":\"Armenia\",\"KoreaName\":\"아르메니아\",\"NationCode\":\"AM\"},");
        sb.AppendLine("{\"EngName\":\"Aruba\",\"KoreaName\":\"아루바\",\"NationCode\":\"AW\"},");
        sb.AppendLine("{\"EngName\":\"Australia\",\"KoreaName\":\"오스트레일리아\",\"NationCode\":\"AU\"},");
        sb.AppendLine("{\"EngName\":\"Austria\",\"KoreaName\":\"오스트리아\",\"NationCode\":\"AT\"},");
        sb.AppendLine("{\"EngName\":\"Azerbaijan\",\"KoreaName\":\"아제르바이잔\",\"NationCode\":\"AZ\"},");
        sb.AppendLine("{\"EngName\":\"Bahamas\",\"KoreaName\":\"바하마\",\"NationCode\":\"BS\"},");
        sb.AppendLine("{\"EngName\":\"Bahrain\",\"KoreaName\":\"바레인\",\"NationCode\":\"BH\"},");
        sb.AppendLine("{\"EngName\":\"Bangladesh\",\"KoreaName\":\"방글라데시\",\"NationCode\":\"BD\"},");
        sb.AppendLine("{\"EngName\":\"Barbados\",\"KoreaName\":\"바베이도스\",\"NationCode\":\"BB\"},");
        sb.AppendLine("{\"EngName\":\"Belarus\",\"KoreaName\":\"벨라루스\",\"NationCode\":\"BY\"},");
        sb.AppendLine("{\"EngName\":\"Belgium\",\"KoreaName\":\"벨기에\",\"NationCode\":\"BE\"},");
        sb.AppendLine("{\"EngName\":\"Belize\",\"KoreaName\":\"벨리즈\",\"NationCode\":\"BZ\"},");
        sb.AppendLine("{\"EngName\":\"Benin\",\"KoreaName\":\"베냉\",\"NationCode\":\"BJ\"},");
        sb.AppendLine("{\"EngName\":\"Bermuda\",\"KoreaName\":\"버뮤다\",\"NationCode\":\"BM\"},");
        sb.AppendLine("{\"EngName\":\"Bhutan\",\"KoreaName\":\"부탄\",\"NationCode\":\"BT\"},");
        sb.AppendLine("{\"EngName\":\"Bolivia\",\"KoreaName\":\"볼리비아\",\"NationCode\":\"BO\"},");
        sb.AppendLine("{\"EngName\":\"Caribbean Netherlands\",\"KoreaName\":\"카리브 네덜란드\",\"NationCode\":\"BQ\"},");
        sb.AppendLine("{\"EngName\":\"Bosnia\",\"KoreaName\":\"보스니아\",\"NationCode\":\"BA\"},");
        sb.AppendLine("{\"EngName\":\"Botswana\",\"KoreaName\":\"보츠와나\",\"NationCode\":\"BW\"},");
        sb.AppendLine("{\"EngName\":\"Bouvet Island\",\"KoreaName\":\"부베 섬\",\"NationCode\":\"BV\"},");
        sb.AppendLine("{\"EngName\":\"Brazil\",\"KoreaName\":\"브라질\",\"NationCode\":\"BR\"},");
        sb.AppendLine("{\"EngName\":\"British Indian Ocean Territory\",\"KoreaName\":\"영국령 인도양 지역\",\"NationCode\":\"IO\"},");
        sb.AppendLine("{\"EngName\":\"British Virgin Islands\",\"KoreaName\":\"영국령 버진아일랜드\",\"NationCode\":\"VG\"},");
        sb.AppendLine("{\"EngName\":\"Brunei\",\"KoreaName\":\"브루나이\",\"NationCode\":\"BN\"},");
        sb.AppendLine("{\"EngName\":\"Bulgaria\",\"KoreaName\":\"불가리아\",\"NationCode\":\"BG\"},");
        sb.AppendLine("{\"EngName\":\"Burkina Faso\",\"KoreaName\":\"부르키나파소\",\"NationCode\":\"BF\"},");
        sb.AppendLine("{\"EngName\":\"Burundi\",\"KoreaName\":\"부룬디\",\"NationCode\":\"BI\"},");
        sb.AppendLine("{\"EngName\":\"Cape Verde\",\"KoreaName\":\"카보베르데\",\"NationCode\":\"CV\"},");
        sb.AppendLine("{\"EngName\":\"Cambodia\",\"KoreaName\":\"캄보디아\",\"NationCode\":\"KH\"},");
        sb.AppendLine("{\"EngName\":\"Cameroon\",\"KoreaName\":\"카메룬\",\"NationCode\":\"CM\"},");
        sb.AppendLine("{\"EngName\":\"Canada\",\"KoreaName\":\"캐나다\",\"NationCode\":\"CA\"},");
        sb.AppendLine("{\"EngName\":\"Cayman Islands\",\"KoreaName\":\"케이맨 제도\",\"NationCode\":\"KY\"},");
        sb.AppendLine("{\"EngName\":\"Central African Republic\",\"KoreaName\":\"중앙 아프리카 공화국\",\"NationCode\":\"CF\"},");
        sb.AppendLine("{\"EngName\":\"Chad\",\"KoreaName\":\"차드\",\"NationCode\":\"TD\"},");
        sb.AppendLine("{\"EngName\":\"Chile\",\"KoreaName\":\"칠레\",\"NationCode\":\"CL\"},");
        sb.AppendLine("{\"EngName\":\"China\",\"KoreaName\":\"중국\",\"NationCode\":\"CN\"},");
        sb.AppendLine("{\"EngName\":\"Hong Kong\",\"KoreaName\":\"홍콩\",\"NationCode\":\"HK\"},");
        sb.AppendLine("{\"EngName\":\"Macau\",\"KoreaName\":\"마카오\",\"NationCode\":\"MO\"},");
        sb.AppendLine("{\"EngName\":\"Christmas Island\",\"KoreaName\":\"크리스마스 섬\",\"NationCode\":\"CX\"},");
        sb.AppendLine("{\"EngName\":\"Cocos (Keeling) Islands\",\"KoreaName\":\"코코스 제도\",\"NationCode\":\"CC\"},");
        sb.AppendLine("{\"EngName\":\"Colombia\",\"KoreaName\":\"콜롬비아\",\"NationCode\":\"CO\"},");
        sb.AppendLine("{\"EngName\":\"Comoros\",\"KoreaName\":\"코모로\",\"NationCode\":\"KM\"},");
        sb.AppendLine("{\"EngName\":\"Congo - Brazzaville\",\"KoreaName\":\"콩고 공화국\",\"NationCode\":\"CG\"},");
        sb.AppendLine("{\"EngName\":\"Cook Islands\",\"KoreaName\":\"쿡 제도\",\"NationCode\":\"CK\"},");
        sb.AppendLine("{\"EngName\":\"Costa Rica\",\"KoreaName\":\"코스타리카\",\"NationCode\":\"CR\"},");
        sb.AppendLine("{\"EngName\":\"Croatia\",\"KoreaName\":\"크로아티아\",\"NationCode\":\"HR\"},");
        sb.AppendLine("{\"EngName\":\"Cuba\",\"KoreaName\":\"쿠바\",\"NationCode\":\"CU\"},");
        sb.AppendLine("{\"EngName\":\"Curaçao\",\"KoreaName\":\"퀴라소\",\"NationCode\":\"CW\"},");
        sb.AppendLine("{\"EngName\":\"Cyprus\",\"KoreaName\":\"키프로스\",\"NationCode\":\"CY\"},");
        sb.AppendLine("{\"EngName\":\"Czechia\",\"KoreaName\":\"체코\",\"NationCode\":\"CZ\"},");
        sb.AppendLine("{\"EngName\":\"Côte d’Ivoire\",\"KoreaName\":\"코트디부아르\",\"NationCode\":\"CI\"},");
        sb.AppendLine("{\"EngName\":\"North Korea\",\"KoreaName\":\"북한\",\"NationCode\":\"KP\"},");
        sb.AppendLine("{\"EngName\":\"Congo - Kinshasa\",\"KoreaName\":\"콩고 민주 공화국\",\"NationCode\":\"CD\"},");
        sb.AppendLine("{\"EngName\":\"Denmark\",\"KoreaName\":\"덴마크\",\"NationCode\":\"DK\"},");
        sb.AppendLine("{\"EngName\":\"Djibouti\",\"KoreaName\":\"지부티\",\"NationCode\":\"DJ\"},");
        sb.AppendLine("{\"EngName\":\"Dominica\",\"KoreaName\":\"도미니카\",\"NationCode\":\"DM\"},");
        sb.AppendLine("{\"EngName\":\"Dominican Republic\",\"KoreaName\":\"도미니카 공화국\",\"NationCode\":\"DO\"},");
        sb.AppendLine("{\"EngName\":\"Ecuador\",\"KoreaName\":\"에콰도르\",\"NationCode\":\"EC\"},");
        sb.AppendLine("{\"EngName\":\"Egypt\",\"KoreaName\":\"이집트\",\"NationCode\":\"EG\"},");
        sb.AppendLine("{\"EngName\":\"El Salvador\",\"KoreaName\":\"엘살바도르\",\"NationCode\":\"SV\"},");
        sb.AppendLine("{\"EngName\":\"Equatorial Guinea\",\"KoreaName\":\"적도 기니\",\"NationCode\":\"GQ\"},");
        sb.AppendLine("{\"EngName\":\"Eritrea\",\"KoreaName\":\"에리트레아\",\"NationCode\":\"ER\"},");
        sb.AppendLine("{\"EngName\":\"Estonia\",\"KoreaName\":\"에스토니아\",\"NationCode\":\"EE\"},");
        sb.AppendLine("{\"EngName\":\"Eswatini\",\"KoreaName\":\"에스와티니\",\"NationCode\":\"SZ\"},");
        sb.AppendLine("{\"EngName\":\"Ethiopia\",\"KoreaName\":\"에티오피아\",\"NationCode\":\"ET\"},");
        sb.AppendLine("{\"EngName\":\"Falkland Islands\",\"KoreaName\":\"포클랜드 제도\",\"NationCode\":\"FK\"},");
        sb.AppendLine("{\"EngName\":\"Faroe Islands\",\"KoreaName\":\"페로 제도\",\"NationCode\":\"FO\"},");
        sb.AppendLine("{\"EngName\":\"Fiji\",\"KoreaName\":\"피지\",\"NationCode\":\"FJ\"},");
        sb.AppendLine("{\"EngName\":\"Finland\",\"KoreaName\":\"핀란드\",\"NationCode\":\"FI\"},");
        sb.AppendLine("{\"EngName\":\"France\",\"KoreaName\":\"프랑스\",\"NationCode\":\"FR\"},");
        sb.AppendLine("{\"EngName\":\"French Guiana\",\"KoreaName\":\"프랑스령 기아나\",\"NationCode\":\"GF\"},");
        sb.AppendLine("{\"EngName\":\"French Polynesia\",\"KoreaName\":\"프랑스령 폴리네시아\",\"NationCode\":\"PF\"},");
        sb.AppendLine("{\"EngName\":\"French Southern Territories\",\"KoreaName\":\"프랑스령 남방 및 남극 지역\",\"NationCode\":\"TF\"},");
        sb.AppendLine("{\"EngName\":\"Gabon\",\"KoreaName\":\"가봉\",\"NationCode\":\"GA\"},");
        sb.AppendLine("{\"EngName\":\"Gambia\",\"KoreaName\":\"감비아\",\"NationCode\":\"GM\"},");
        sb.AppendLine("{\"EngName\":\"Georgia\",\"KoreaName\":\"조지아\",\"NationCode\":\"GE\"},");
        sb.AppendLine("{\"EngName\":\"Germany\",\"KoreaName\":\"독일\",\"NationCode\":\"DE\"},");
        sb.AppendLine("{\"EngName\":\"Ghana\",\"KoreaName\":\"가나\",\"NationCode\":\"GH\"},");
        sb.AppendLine("{\"EngName\":\"Gibraltar\",\"KoreaName\":\"지브롤터\",\"NationCode\":\"GI\"},");
        sb.AppendLine("{\"EngName\":\"Greece\",\"KoreaName\":\"그리스\",\"NationCode\":\"GR\"},");
        sb.AppendLine("{\"EngName\":\"Greenland\",\"KoreaName\":\"그린란드\",\"NationCode\":\"GL\"},");
        sb.AppendLine("{\"EngName\":\"Grenada\",\"KoreaName\":\"그레나다\",\"NationCode\":\"GD\"},");
        sb.AppendLine("{\"EngName\":\"Guadeloupe\",\"KoreaName\":\"과들루프\",\"NationCode\":\"GP\"},");
        sb.AppendLine("{\"EngName\":\"Guam\",\"KoreaName\":\"괌\",\"NationCode\":\"GU\"},");
        sb.AppendLine("{\"EngName\":\"Guatemala\",\"KoreaName\":\"과테말라\",\"NationCode\":\"GT\"},");
        sb.AppendLine("{\"EngName\":\"Guernsey\",\"KoreaName\":\"건지 섬\",\"NationCode\":\"GG\"},");
        sb.AppendLine("{\"EngName\":\"Guinea\",\"KoreaName\":\"기니\",\"NationCode\":\"GN\"},");
        sb.AppendLine("{\"EngName\":\"Guinea-Bissau\",\"KoreaName\":\"기니비사우\",\"NationCode\":\"GW\"},");
        sb.AppendLine("{\"EngName\":\"Guyana\",\"KoreaName\":\"가이아나\",\"NationCode\":\"GY\"},");
        sb.AppendLine("{\"EngName\":\"Haiti\",\"KoreaName\":\"아이티\",\"NationCode\":\"HT\"},");
        sb.AppendLine("{\"EngName\":\"Heard & McDonald Islands\",\"KoreaName\":\"허드 맥도날드 제도\",\"NationCode\":\"HM\"},");
        sb.AppendLine("{\"EngName\":\"Vatican City\",\"KoreaName\":\"바티칸 시티\",\"NationCode\":\"VA\"},");
        sb.AppendLine("{\"EngName\":\"Honduras\",\"KoreaName\":\"온두라스\",\"NationCode\":\"HN\"},");
        sb.AppendLine("{\"EngName\":\"Hungary\",\"KoreaName\":\"헝가리\",\"NationCode\":\"HU\"},");
        sb.AppendLine("{\"EngName\":\"Iceland\",\"KoreaName\":\"아이슬란드\",\"NationCode\":\"IS\"},");
        sb.AppendLine("{\"EngName\":\"India\",\"KoreaName\":\"인도\",\"NationCode\":\"IN\"},");
        sb.AppendLine("{\"EngName\":\"Indonesia\",\"KoreaName\":\"인도네시아\",\"NationCode\":\"ID\"},");
        sb.AppendLine("{\"EngName\":\"Iran\",\"KoreaName\":\"이란\",\"NationCode\":\"IR\"},");
        sb.AppendLine("{\"EngName\":\"Iraq\",\"KoreaName\":\"이라크\",\"NationCode\":\"IQ\"},");
        sb.AppendLine("{\"EngName\":\"Ireland\",\"KoreaName\":\"아일랜드\",\"NationCode\":\"IE\"},");
        sb.AppendLine("{\"EngName\":\"Isle of Man\",\"KoreaName\":\"맨 섬\",\"NationCode\":\"IM\"},");
        sb.AppendLine("{\"EngName\":\"Israel\",\"KoreaName\":\"이스라엘\",\"NationCode\":\"IL\"},");
        sb.AppendLine("{\"EngName\":\"Italy\",\"KoreaName\":\"이탈리아\",\"NationCode\":\"IT\"},");
        sb.AppendLine("{\"EngName\":\"Jamaica\",\"KoreaName\":\"자메이카\",\"NationCode\":\"JM\"},");
        sb.AppendLine("{\"EngName\":\"Japan\",\"KoreaName\":\"일본\",\"NationCode\":\"JP\"},");
        sb.AppendLine("{\"EngName\":\"Jersey\",\"KoreaName\":\"저지 섬\",\"NationCode\":\"JE\"},");
        sb.AppendLine("{\"EngName\":\"Jordan\",\"KoreaName\":\"요르단\",\"NationCode\":\"JO\"},");
        sb.AppendLine("{\"EngName\":\"Kazakhstan\",\"KoreaName\":\"카자흐스탄\",\"NationCode\":\"KZ\"},");
        sb.AppendLine("{\"EngName\":\"Kenya\",\"KoreaName\":\"케냐\",\"NationCode\":\"KE\"},");
        sb.AppendLine("{\"EngName\":\"Kiribati\",\"KoreaName\":\"키리바시\",\"NationCode\":\"KI\"},");
        sb.AppendLine("{\"EngName\":\"Kuwait\",\"KoreaName\":\"쿠웨이트\",\"NationCode\":\"KW\"},");
        sb.AppendLine("{\"EngName\":\"Kyrgyzstan\",\"KoreaName\":\"키르기스스탄\",\"NationCode\":\"KG\"},");
        sb.AppendLine("{\"EngName\":\"Laos\",\"KoreaName\":\"라오스\",\"NationCode\":\"LA\"},");
        sb.AppendLine("{\"EngName\":\"Latvia\",\"KoreaName\":\"라트비아\",\"NationCode\":\"LV\"},");
        sb.AppendLine("{\"EngName\":\"Lebanon\",\"KoreaName\":\"레바논\",\"NationCode\":\"LB\"},");
        sb.AppendLine("{\"EngName\":\"Lesotho\",\"KoreaName\":\"레소토\",\"NationCode\":\"LS\"},");
        sb.AppendLine("{\"EngName\":\"Liberia\",\"KoreaName\":\"라이베리아\",\"NationCode\":\"LR\"},");
        sb.AppendLine("{\"EngName\":\"Libya\",\"KoreaName\":\"리비아\",\"NationCode\":\"LY\"},");
        sb.AppendLine("{\"EngName\":\"Liechtenstein\",\"KoreaName\":\"리히텐슈타인\",\"NationCode\":\"LI\"},");
        sb.AppendLine("{\"EngName\":\"Lithuania\",\"KoreaName\":\"리투아니아\",\"NationCode\":\"LT\"},");
        sb.AppendLine("{\"EngName\":\"Luxembourg\",\"KoreaName\":\"룩셈부르크\",\"NationCode\":\"LU\"},");
        sb.AppendLine("{\"EngName\":\"Madagascar\",\"KoreaName\":\"마다가스카르\",\"NationCode\":\"MG\"},");
        sb.AppendLine("{\"EngName\":\"Malawi\",\"KoreaName\":\"말라위\",\"NationCode\":\"MW\"},");
        sb.AppendLine("{\"EngName\":\"Malaysia\",\"KoreaName\":\"말레이시아\",\"NationCode\":\"MY\"},");
        sb.AppendLine("{\"EngName\":\"Maldives\",\"KoreaName\":\"몰디브\",\"NationCode\":\"MV\"},");
        sb.AppendLine("{\"EngName\":\"Mali\",\"KoreaName\":\"말리\",\"NationCode\":\"ML\"},");
        sb.AppendLine("{\"EngName\":\"Malta\",\"KoreaName\":\"몰타\",\"NationCode\":\"MT\"},");
        sb.AppendLine("{\"EngName\":\"Marshall Islands\",\"KoreaName\":\"마셜 제도\",\"NationCode\":\"MH\"},");
        sb.AppendLine("{\"EngName\":\"Martinique\",\"KoreaName\":\"마르티니크\",\"NationCode\":\"MQ\"},");
        sb.AppendLine("{\"EngName\":\"Mauritania\",\"KoreaName\":\"모리타니\",\"NationCode\":\"MR\"},");
        sb.AppendLine("{\"EngName\":\"Mauritius\",\"KoreaName\":\"모리셔스\",\"NationCode\":\"MU\"},");
        sb.AppendLine("{\"EngName\":\"Mayotte\",\"KoreaName\":\"마요트\",\"NationCode\":\"YT\"},");
        sb.AppendLine("{\"EngName\":\"Mexico\",\"KoreaName\":\"멕시코\",\"NationCode\":\"MX\"},");
        sb.AppendLine("{\"EngName\":\"Micronesia\",\"KoreaName\":\"미크로네시아\",\"NationCode\":\"FM\"},");
        sb.AppendLine("{\"EngName\":\"Monaco\",\"KoreaName\":\"모나코\",\"NationCode\":\"MC\"},");
        sb.AppendLine("{\"EngName\":\"Mongolia\",\"KoreaName\":\"몽골\",\"NationCode\":\"MN\"},");
        sb.AppendLine("{\"EngName\":\"Montenegro\",\"KoreaName\":\"몬테네그로\",\"NationCode\":\"ME\"},");
        sb.AppendLine("{\"EngName\":\"Montserrat\",\"KoreaName\":\"몬세라트\",\"NationCode\":\"MS\"},");
        sb.AppendLine("{\"EngName\":\"Morocco\",\"KoreaName\":\"모로코\",\"NationCode\":\"MA\"},");
        sb.AppendLine("{\"EngName\":\"Mozambique\",\"KoreaName\":\"모잠비크\",\"NationCode\":\"MZ\"},");
        sb.AppendLine("{\"EngName\":\"Myanmar\",\"KoreaName\":\"미얀마\",\"NationCode\":\"MM\"},");
        sb.AppendLine("{\"EngName\":\"Namibia\",\"KoreaName\":\"나미비아\",\"NationCode\":\"NA\"},");
        sb.AppendLine("{\"EngName\":\"Nauru\",\"KoreaName\":\"나우루\",\"NationCode\":\"NR\"},");
        sb.AppendLine("{\"EngName\":\"Nepal\",\"KoreaName\":\"네팔\",\"NationCode\":\"NP\"},");
        sb.AppendLine("{\"EngName\":\"Netherlands\",\"KoreaName\":\"네덜란드\",\"NationCode\":\"NL\"},");
        sb.AppendLine("{\"EngName\":\"New Caledonia\",\"KoreaName\":\"뉴칼레도니아\",\"NationCode\":\"NC\"},");
        sb.AppendLine("{\"EngName\":\"New Zealand\",\"KoreaName\":\"뉴질랜드\",\"NationCode\":\"NZ\"},");
        sb.AppendLine("{\"EngName\":\"Nicaragua\",\"KoreaName\":\"니카라과\",\"NationCode\":\"NI\"},");
        sb.AppendLine("{\"EngName\":\"Niger\",\"KoreaName\":\"니제르\",\"NationCode\":\"NE\"},");
        sb.AppendLine("{\"EngName\":\"Nigeria\",\"KoreaName\":\"나이지리아\",\"NationCode\":\"NG\"},");
        sb.AppendLine("{\"EngName\":\"Niue\",\"KoreaName\":\"니우\",\"NationCode\":\"NU\"},");
        sb.AppendLine("{\"EngName\":\"Norfolk Island\",\"KoreaName\":\"노퍽 섬\",\"NationCode\":\"NF\"},");
        sb.AppendLine("{\"EngName\":\"Northern Mariana Islands\",\"KoreaName\":\"북마리아나 제도\",\"NationCode\":\"MP\"},");
        sb.AppendLine("{\"EngName\":\"Norway\",\"KoreaName\":\"노르웨이\",\"NationCode\":\"NO\"},");
        sb.AppendLine("{\"EngName\":\"Oman\",\"KoreaName\":\"오만\",\"NationCode\":\"OM\"},");
        sb.AppendLine("{\"EngName\":\"Pakistan\",\"KoreaName\":\"파키스탄\",\"NationCode\":\"PK\"},");
        sb.AppendLine("{\"EngName\":\"Palau\",\"KoreaName\":\"팔라우\",\"NationCode\":\"PW\"},");
        sb.AppendLine("{\"EngName\":\"Panama\",\"KoreaName\":\"파나마\",\"NationCode\":\"PA\"},");
        sb.AppendLine("{\"EngName\":\"Papua New Guinea\",\"KoreaName\":\"파푸아뉴기니\",\"NationCode\":\"PG\"},");
        sb.AppendLine("{\"EngName\":\"Paraguay\",\"KoreaName\":\"파라과이\",\"NationCode\":\"PY\"},");
        sb.AppendLine("{\"EngName\":\"Peru\",\"KoreaName\":\"페루\",\"NationCode\":\"PE\"},");
        sb.AppendLine("{\"EngName\":\"Philippines\",\"KoreaName\":\"필리핀\",\"NationCode\":\"PH\"},");
        sb.AppendLine("{\"EngName\":\"Pitcairn Islands\",\"KoreaName\":\"핏케언 제도\",\"NationCode\":\"PN\"},");
        sb.AppendLine("{\"EngName\":\"Poland\",\"KoreaName\":\"폴란드\",\"NationCode\":\"PL\"},");
        sb.AppendLine("{\"EngName\":\"Portugal\",\"KoreaName\":\"포르투갈\",\"NationCode\":\"PT\"},");
        sb.AppendLine("{\"EngName\":\"Puerto Rico\",\"KoreaName\":\"푸에르토리코\",\"NationCode\":\"PR\"},");
        sb.AppendLine("{\"EngName\":\"Qatar\",\"KoreaName\":\"카타르\",\"NationCode\":\"QA\"},");
        sb.AppendLine("{\"EngName\":\"South Korea\",\"KoreaName\":\"대한민국\",\"NationCode\":\"KR\"},");
        sb.AppendLine("{\"EngName\":\"Moldova\",\"KoreaName\":\"몰도바\",\"NationCode\":\"MD\"},");
        sb.AppendLine("{\"EngName\":\"Romania\",\"KoreaName\":\"루마니아\",\"NationCode\":\"RO\"},");
        sb.AppendLine("{\"EngName\":\"Russia\",\"KoreaName\":\"러시아\",\"NationCode\":\"RU\"},");
        sb.AppendLine("{\"EngName\":\"Rwanda\",\"KoreaName\":\"르완다\",\"NationCode\":\"RW\"},");
        sb.AppendLine("{\"EngName\":\"Réunion\",\"KoreaName\":\"레위니옹\",\"NationCode\":\"RE\"},");
        sb.AppendLine("{\"EngName\":\"St. Barthélemy\",\"KoreaName\":\"생바르텔레미\",\"NationCode\":\"BL\"},");
        sb.AppendLine("{\"EngName\":\"St. Helena\",\"KoreaName\":\"세인트헬레나\",\"NationCode\":\"SH\"},");
        sb.AppendLine("{\"EngName\":\"St. Kitts & Nevis\",\"KoreaName\":\"세인트키츠네비스\",\"NationCode\":\"KN\"},");
        sb.AppendLine("{\"EngName\":\"St. Lucia\",\"KoreaName\":\"세인트루시아\",\"NationCode\":\"LC\"},");
        sb.AppendLine("{\"EngName\":\"St. Martin\",\"KoreaName\":\"세인트마틴\",\"NationCode\":\"MF\"},");
        sb.AppendLine("{\"EngName\":\"St. Pierre & Miquelon\",\"KoreaName\":\"생피에르 미클롱\",\"NationCode\":\"PM\"},");
        sb.AppendLine("{\"EngName\":\"St. Vincent & Grenadines\",\"KoreaName\":\"세인트빈센트 그레나딘\",\"NationCode\":\"VC\"},");
        sb.AppendLine("{\"EngName\":\"Samoa\",\"KoreaName\":\"사모아\",\"NationCode\":\"WS\"},");
        sb.AppendLine("{\"EngName\":\"San Marino\",\"KoreaName\":\"산마리노\",\"NationCode\":\"SM\"},");
        sb.AppendLine("{\"EngName\":\"São Tomé & Príncipe\",\"KoreaName\":\"상투메 프린시페\",\"NationCode\":\"ST\"},");
        sb.AppendLine("{\"EngName\":\"Saudi Arabia\",\"KoreaName\":\"사우디아라비아\",\"NationCode\":\"SA\"},");
        sb.AppendLine("{\"EngName\":\"Senegal\",\"KoreaName\":\"세네갈\",\"NationCode\":\"SN\"},");
        sb.AppendLine("{\"EngName\":\"Serbia\",\"KoreaName\":\"세르비아\",\"NationCode\":\"RS\"},");
        sb.AppendLine("{\"EngName\":\"Seychelles\",\"KoreaName\":\"세이셸\",\"NationCode\":\"SC\"},");
        sb.AppendLine("{\"EngName\":\"Sierra Leone\",\"KoreaName\":\"시에라리온\",\"NationCode\":\"SL\"},");
        sb.AppendLine("{\"EngName\":\"Singapore\",\"KoreaName\":\"싱가포르\",\"NationCode\":\"SG\"},");
        sb.AppendLine("{\"EngName\":\"Sint Maarten\",\"KoreaName\":\"신트마르턴\",\"NationCode\":\"SX\"},");
        sb.AppendLine("{\"EngName\":\"Slovakia\",\"KoreaName\":\"슬로바키아\",\"NationCode\":\"SK\"},");
        sb.AppendLine("{\"EngName\":\"Slovenia\",\"KoreaName\":\"슬로베니아\",\"NationCode\":\"SI\"},");
        sb.AppendLine("{\"EngName\":\"Solomon Islands\",\"KoreaName\":\"솔로몬 제도\",\"NationCode\":\"SB\"},");
        sb.AppendLine("{\"EngName\":\"Somalia\",\"KoreaName\":\"소말리아\",\"NationCode\":\"SO\"},");
        sb.AppendLine("{\"EngName\":\"South Africa\",\"KoreaName\":\"남아프리카 공화국\",\"NationCode\":\"ZA\"},");
        sb.AppendLine("{\"EngName\":\"South Georgia & South Sandwich Islands\",\"KoreaName\":\"사우스조지아와 사우스샌드위치 제도\",\"NationCode\":\"GS\"},");
        sb.AppendLine("{\"EngName\":\"South Sudan\",\"KoreaName\":\"남수단\",\"NationCode\":\"SS\"},");
        sb.AppendLine("{\"EngName\":\"Spain\",\"KoreaName\":\"스페인\",\"NationCode\":\"ES\"},");
        sb.AppendLine("{\"EngName\":\"Sri Lanka\",\"KoreaName\":\"스리랑카\",\"NationCode\":\"LK\"},");
        sb.AppendLine("{\"EngName\":\"Palestine\",\"KoreaName\":\"팔레스타인\",\"NationCode\":\"PS\"},");
        sb.AppendLine("{\"EngName\":\"Sudan\",\"KoreaName\":\"수단\",\"NationCode\":\"SD\"},");
        sb.AppendLine("{\"EngName\":\"Suriname\",\"KoreaName\":\"수리남\",\"NationCode\":\"SR\"},");
        sb.AppendLine("{\"EngName\":\"Svalbard & Jan Mayen\",\"KoreaName\":\"스발바르 얀마옌\",\"NationCode\":\"SJ\"},");
        sb.AppendLine("{\"EngName\":\"Sweden\",\"KoreaName\":\"스웨덴\",\"NationCode\":\"SE\"},");
        sb.AppendLine("{\"EngName\":\"Switzerland\",\"KoreaName\":\"스위스\",\"NationCode\":\"CH\"},");
        sb.AppendLine("{\"EngName\":\"Syria\",\"KoreaName\":\"시리아\",\"NationCode\":\"SY\"},");
        sb.AppendLine("{\"EngName\":\"Tajikistan\",\"KoreaName\":\"타지키스탄\",\"NationCode\":\"TJ\"},");
        sb.AppendLine("{\"EngName\":\"Thailand\",\"KoreaName\":\"태국\",\"NationCode\":\"TH\"},");
        sb.AppendLine("{\"EngName\":\"North Macedonia\",\"KoreaName\":\"북마케도니아\",\"NationCode\":\"MK\"},");
        sb.AppendLine("{\"EngName\":\"Timor-Leste\",\"KoreaName\":\"동티모르\",\"NationCode\":\"TL\"},");
        sb.AppendLine("{\"EngName\":\"Togo\",\"KoreaName\":\"토고\",\"NationCode\":\"TG\"},");
        sb.AppendLine("{\"EngName\":\"Tokelau\",\"KoreaName\":\"토켈라우\",\"NationCode\":\"TK\"},");
        sb.AppendLine("{\"EngName\":\"Tonga\",\"KoreaName\":\"통가\",\"NationCode\":\"TO\"},");
        sb.AppendLine("{\"EngName\":\"Trinidad & Tobago\",\"KoreaName\":\"트리니다드 토바고\",\"NationCode\":\"TT\"},");
        sb.AppendLine("{\"EngName\":\"Tunisia\",\"KoreaName\":\"튀니지\",\"NationCode\":\"TN\"},");
        sb.AppendLine("{\"EngName\":\"Turkey\",\"KoreaName\":\"터키\",\"NationCode\":\"TR\"},");
        sb.AppendLine("{\"EngName\":\"Turkmenistan\",\"KoreaName\":\"투르크메니스탄\",\"NationCode\":\"TM\"},");
        sb.AppendLine("{\"EngName\":\"Turks & Caicos Islands\",\"KoreaName\":\"터크스 케이커스 제도\",\"NationCode\":\"TC\"},");
        sb.AppendLine("{\"EngName\":\"Tuvalu\",\"KoreaName\":\"투발루\",\"NationCode\":\"TV\"},");
        sb.AppendLine("{\"EngName\":\"Uganda\",\"KoreaName\":\"우간다\",\"NationCode\":\"UG\"},");
        sb.AppendLine("{\"EngName\":\"Ukraine\",\"KoreaName\":\"우크라이나\",\"NationCode\":\"UA\"},");
        sb.AppendLine("{\"EngName\":\"United Arab Emirates\",\"KoreaName\":\"아랍에미리트\",\"NationCode\":\"AE\"},");
        sb.AppendLine("{\"EngName\":\"UK\",\"KoreaName\":\"영국\",\"NationCode\":\"GB\"},");
        sb.AppendLine("{\"EngName\":\"Tanzania\",\"KoreaName\":\"탄자니아\",\"NationCode\":\"TZ\"},");
        sb.AppendLine("{\"EngName\":\"U.S. Outlying Islands\",\"KoreaName\":\"미국령 외진 제도\",\"NationCode\":\"UM\"},");
        sb.AppendLine("{\"EngName\":\"U.S. Virgin Islands\",\"KoreaName\":\"미국령 버진 아일랜드\",\"NationCode\":\"VI\"},");
        sb.AppendLine("{\"EngName\":\"US\",\"KoreaName\":\"미국\",\"NationCode\":\"US\"},");
        sb.AppendLine("{\"EngName\":\"Uruguay\",\"KoreaName\":\"우루과이\",\"NationCode\":\"UY\"},");
        sb.AppendLine("{\"EngName\":\"Uzbekistan\",\"KoreaName\":\"우즈베키스탄\",\"NationCode\":\"UZ\"},");
        sb.AppendLine("{\"EngName\":\"Vanuatu\",\"KoreaName\":\"바누아투\",\"NationCode\":\"VU\"},");
        sb.AppendLine("{\"EngName\":\"Venezuela\",\"KoreaName\":\"베네수엘라\",\"NationCode\":\"VE\"},");
        sb.AppendLine("{\"EngName\":\"Vietnam\",\"KoreaName\":\"베트남\",\"NationCode\":\"VN\"},");
        sb.AppendLine("{\"EngName\":\"Wallis & Futuna\",\"KoreaName\":\"왈리스 퓌튀나\",\"NationCode\":\"WF\"},");
        sb.AppendLine("{\"EngName\":\"Western Sahara\",\"KoreaName\":\"서사하라\",\"NationCode\":\"EH\"},");
        sb.AppendLine("{\"EngName\":\"Yemen\",\"KoreaName\":\"예멘\",\"NationCode\":\"YE\"},");
        sb.AppendLine("{\"EngName\":\"Zambia\",\"KoreaName\":\"잠비아\",\"NationCode\":\"ZM\"},");
        sb.AppendLine("{\"EngName\":\"Zimbabwe\",\"KoreaName\":\"짐바브웨\",\"NationCode\":\"ZW\"},");
        sb.AppendLine("{\"EngName\":\"Åland Islands\",\"KoreaName\":\"올란드 제도\",\"NationCode\":\"AX\"}");
        sb.AppendLine("]");
        nation = JsonConvert.DeserializeObject<List<NationCodeInfo>>(sb.ToString());
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