using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderContainerPrintPeriod : PageBase
    {
        OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();

        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strOrderNos1        = string.Empty;
            string lo_strOrderNos2        = string.Empty;
            string lo_strSaleClosingSeqNo = string.Empty;

            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value = "1";

            lo_strOrderNos1        = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos1"),        string.Empty);
            lo_strOrderNos2        = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos2"),        string.Empty);
            lo_strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");

            if (!lo_strSaleClosingSeqNo.Equals("0"))
            {
                SaleClosingChk.Visible = false;
            }

            OrderNos1.Value        = lo_strOrderNos1;
            OrderNos2.Value        = lo_strOrderNos2;
            SaleClosingSeqNo.Value = lo_strSaleClosingSeqNo;
            hidPage.Value          = HttpContext.Current.Request.Url.AbsoluteUri;
            HidGridID.Value        = SiteGlobal.GetRequestForm("GridID");
            CenterCode.Value       = SiteGlobal.GetRequestForm("CenterCode");
            ClientCode.Value       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), string.Empty);
            SendMail.Text          = objSes.Email;
            PdfFlag.Value          = Utils.IsNull(SiteGlobal.GetRequestForm("PdfFlag"), "N");
            AdminName.Value        = objSes.AdminName;
            AdminID.Value          = objSes.AdminID;
            AdminTel.Value         = objSes.TelNo;
            AdminMobile.Value      = objSes.MobileNo;
            DeptName.Value         = objSes.DeptName;
            AdminPosition.Value    = objSes.Position;
            AdminMail.Value        = objSes.Email;

            CLIENT_CHARGE_DDLB(ChargeNameList, CenterCode.Value, ClientCode.Value);

            if (PdfFlag.Value.Equals("Y"))
            {
                BtnArea.Visible = false;
            }

            DisplayData();
        }

        public static void CLIENT_CHARGE_DDLB(DropDownList DDLB, string lo_strCenterCode, string lo_strClientCode)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("청구담당자", ""));

            ReqClientChargeList                lo_objReqClientChargeList = null;
            ServiceResult<ResClientChargeList> lo_objResClientChargeList = null;
            ClientDasServices                  objClientDasServices      = new ClientDasServices();

            try
            {
                lo_objReqClientChargeList = new ReqClientChargeList
                {
                    CenterCode = lo_strCenterCode.ToInt(),
                    ClientCode = lo_strClientCode.ToInt(),
                    PageSize   = 0,
                    PageNo     = 0
                };

                lo_objResClientChargeList = objClientDasServices.GetClientChargeList(lo_objReqClientChargeList);

                if (lo_objResClientChargeList.result.ErrorCode.IsSuccess())
                {
                    foreach (var item in lo_objResClientChargeList.data.list)
                    {
                        DDLB.Items.Add(new ListItem(item.ChargeName + " (Email : " + (string.IsNullOrWhiteSpace(item.ChargeEmail) ? "미등록" : item.ChargeEmail) + ")", item.ChargeEmail + "^" + item.ChargeName));
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("OrderContainerPrintPeriod", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9301);
            }
        }

        protected void DisplayData()
        {
            ReqOrderDispatchList                       lo_objReqOrderDispatchList        = null;
            ServiceResult<ResOrderDispatchAdvanceList> lo_objResOrderDispatchAdvanceList = null;

            try
            {
                lo_objReqOrderDispatchList = new ReqOrderDispatchList
                {
                    CenterCode       = CenterCode.Value.ToInt(),
                    OrderNos1        = OrderNos1.Value,
                    OrderNos2        = OrderNos2.Value,
                    SaleClosingSeqNo = SaleClosingSeqNo.Value.ToInt64()
                };

                lo_objResOrderDispatchAdvanceList = objOrderDispatchDasServices.GetOrderDispatchAdvanceList(lo_objReqOrderDispatchList);

                if (lo_objResOrderDispatchAdvanceList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value      = "정보를 조회하지 못했습니다.";
                    return;
                }

                GetPrintList(lo_objResOrderDispatchAdvanceList);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("OrderContainerPrintPeriod", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9304);
            }
        }

        protected void GetPrintList(ServiceResult<ResOrderDispatchAdvanceList> lo_objResOrderDispatchAdvanceList)
        {
            ReqOrderDispatchList                lo_objReqOrderDispatchList = null;
            ServiceResult<ResOrderDispatchList> lo_objResOrderDispatchList = null;
            int                                 lo_intListType             = 1;
            string                              objStyleW                  = string.Empty;
            string                              strTb                      = string.Empty;
            string                              strTbList                  = string.Empty;
            string                              strAdvanceTbList           = string.Empty;
            double                              intTotalSupplyAmt          = 0;
            double                              intTotalTaxAmt             = 0;
            double                              intTotalAdvanceOrgAmt      = 0;

            try
            {
                lo_objReqOrderDispatchList = new ReqOrderDispatchList
                {
                    CenterCode       = CenterCode.Value.ToInt(),
                    OrderNos1        = OrderNos1.Value,
                    OrderNos2        = OrderNos2.Value,
                    SaleClosingSeqNo = SaleClosingSeqNo.Value.ToInt64(),
                    ClientCode       = ClientCode.Value.ToInt64(),
                    ListType         = lo_intListType.ToInt()
                };

                lo_objResOrderDispatchList = objOrderDispatchDasServices.GetOrderDispatchPrintList(lo_objReqOrderDispatchList);

                if (lo_objResOrderDispatchList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "정보를 조회하지 못했습니다.";
                    return;
                }

                if (lo_objResOrderDispatchList.data.RecordCnt > 0)
                {
                    ClientName.Value     = lo_objResOrderDispatchList.data.list[0].PayClientName;
                    CenterName.Value     = lo_objResOrderDispatchList.data.list[0].CenterName;
                    SupplyAmtTotal.Value = lo_objResOrderDispatchList.data.SupplyAmtTotal.ToString();
                    TaxAmtTotal.Value    = lo_objResOrderDispatchList.data.TaxAmtTotal.ToString();
                    OrgAmtTotal.Value    = lo_objResOrderDispatchList.data.OrgAmtTotal.ToString();
                    intTotalSupplyAmt    = lo_objResOrderDispatchList.data.SupplyAmtTotal;
                    intTotalTaxAmt       = lo_objResOrderDispatchList.data.TaxAmtTotal;

                    /*선급금,예수금 세팅*/
                    List<string> lo_strDistinctOrderNo = new List<string>();
                    List<int>    lo_strDistinctIndex   = new List<int>();

                    for (int i = 0; i < lo_objResOrderDispatchList.data.list.Count; i++)
                    {
                        string lo_strOrderNo = lo_objResOrderDispatchList.data.list[i].OrderNo;

                        if (!lo_strDistinctOrderNo.Contains(lo_strOrderNo))
                        {
                            lo_strDistinctOrderNo.Add(lo_strOrderNo);
                            lo_strDistinctIndex.Add(i);
                        }
                    }

                    /*항목세팅*/
                    List<string> lo_strDistinctItemCode     = new List<string>();
                    List<string> lo_strDistinctItemCodeName = new List<string>();

                    for (int i = 0; i < lo_objResOrderDispatchList.data.list.Count; i++)
                    {
                        string lo_strItemCode     = lo_objResOrderDispatchList.data.list[i].ItemCode;
                        string lo_strItemCodeName = lo_objResOrderDispatchList.data.list[i].ItemCodeM;

                        if (!lo_strDistinctItemCode.Contains(lo_strItemCode))
                        {
                            lo_strDistinctItemCode.Add(lo_strItemCode);
                            lo_strDistinctItemCodeName.Add(lo_strItemCodeName);
                        }
                    }
                    
                    for (var i = 0; i < lo_strDistinctItemCode.Count; i++)
                    {
                        if (!lo_strDistinctItemCode[i].Equals(""))
                        {
                            double intSupplyAmtTotal = 0;
                            double intTaxAmtTotal    = 0;

                            for (var v = 0; v < lo_objResOrderDispatchList.data.list.Count; v++)
                            {
                                if (lo_strDistinctItemCode[i] == lo_objResOrderDispatchList.data.list[v].ItemCode)
                                {
                                    intSupplyAmtTotal += lo_objResOrderDispatchList.data.list[v].SupplyAmt.ToDouble();
                                    intTaxAmtTotal += lo_objResOrderDispatchList.data.list[v].TaxAmt.ToDouble();
                                }
                            }

                            strTbList += "<tr>";
                            strTbList += "<th>" + lo_strDistinctItemCodeName[i] + "</th>";
                            strTbList += "<td>" + (intSupplyAmtTotal.Equals(0) ? "0" : intSupplyAmtTotal.ToString("##,###")) + "</td>";
                            strTbList += "<td>" + (intTaxAmtTotal.Equals(0) ? "0" : intTaxAmtTotal.ToString("##,###")) + "</td>";
                            strTbList += "</tr>";
                        }
                    }

                    for (var i = 0; i < lo_objResOrderDispatchAdvanceList.data.RecordCnt; i++)
                    {
                        intTotalAdvanceOrgAmt += lo_objResOrderDispatchAdvanceList.data.list[i].OrgAmt;
                        strAdvanceTbList += "<tr>";
                        strAdvanceTbList += $"<th>대납금({lo_objResOrderDispatchAdvanceList.data.list[i].ItemCodeM})</th>";
                        strAdvanceTbList += $"<td>{lo_objResOrderDispatchAdvanceList.data.list[i].SupplyAmt.ToDouble():#,##0}</td>";
                        strAdvanceTbList += $"<td>{lo_objResOrderDispatchAdvanceList.data.list[i].TaxAmt.ToDouble():#,##0}</td>";
                        strAdvanceTbList += "</tr>";
                    }

                    strTb += "<div class=\"page_line\">";

                    for (var f = 0; f < lo_strDistinctIndex.Count; f++)
                    {
                        objStyleW = lo_strDistinctIndex.Count < 12 ? "style=\"height:500px\"" : "style=\"height:auto\"";

                        if (f.Equals(0))
                        {
                            strTb += "<ul class=\"top_ul\">";
                            strTb += "<li>" + lo_objResOrderDispatchList.data.list[f].CenterName + "</li>";
                            strTb += "<li>출력일 : " + DateTime.Now.ToString("yyyy-MM-dd") + "</li>";
                            strTb += "</ul>";
                            strTb += "<h1>운송내역서(기간)_(" + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[f].PickupYMD) + " ~ " + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[lo_objResOrderDispatchList.data.list.Count - 1].PickupYMD) + ")</h1>";
                            strTb += "<table class=\"type_02\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:20%\"/>";
                            strTb += "<col style=\"width:30%\"/>";
                            strTb += "<col style=\"width:20%\"/>";
                            strTb += "<col style=\"width:30%\"/>";
                            strTb += "<thead>";
                            strTb += "<tr>";
                            strTb += "<th>고객사</th>";
                            strTb += "<td>" + lo_objResOrderDispatchList.data.list[f].ClientName + "</td>";
                            strTb += "<th>FAX</th>";
                            strTb += "<td>" + lo_objResOrderDispatchList.data.list[f].ClientFaxNo + "</td>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "</table>";

                            //운송사 정보
                            strTb += "<h2>운송사 정보</h2>";
                            strTb += "<table class=\"type_02\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:20%\"/>";
                            strTb += "<col style=\"width:30%\"/>";
                            strTb += "<col style=\"width:20%\"/>";
                            strTb += "<col style=\"width:30%\"/>";
                            strTb += "</colgroup>";
                            strTb += "<thead class=\"tleft\">";
                            strTb += "<tr>";
                            strTb += "<th>운송사명</th>";
                            strTb += "<td>" + lo_objResOrderDispatchList.data.list[f].CenterNameInfo + "</td>";
                            strTb += "<th>대표번호/팩스</th>";
                            strTb += "<td>" + lo_objResOrderDispatchList.data.list[f].TelNoInfo + " / " + lo_objResOrderDispatchList.data.list[f].FaxNoInfo + "</td>";
                            strTb += "</tr>";
                            strTb += "<tr>";
                            strTb += "<th>주소</th>";
                            strTb += "<td colspan=\"3\">";
                            strTb += lo_objResOrderDispatchList.data.list[f].AddrInfo + "(우편번호 " + lo_objResOrderDispatchList.data.list[f].AddrPostInfo + ")";
                            strTb += "</td>";
                            strTb += "</tr>";
                            strTb += "<tr>";
                            strTb += "<th>계좌정보</th>";
                            strTb += "<td colspan=\"3\">";
                            strTb += "예금주 : " + lo_objResOrderDispatchList.data.list[f].AcctNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;은행명 : " + lo_objResOrderDispatchList.data.list[f].BankNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;계좌번호 : " + lo_objResOrderDispatchList.data.list[f].AcctNo;
                            strTb += "</td>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "</table>";

                            //청구내역
                            strTb += "<h2>청구내역</h2>";
                            strTb += "<table class=\"type_02\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:20%\"/>";
                            strTb += "<col style=\"width:40%\"/>";
                            strTb += "<col style=\"width:40%\"/>";
                            strTb += "</colgroup>";
                            strTb += "<thead>";
                            strTb += "<tr>";
                            strTb += "<th>항목</th>";
                            strTb += "<th>공급가액(원)</th>";
                            strTb += "<th>부가세(원)</th>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "<tbody class=\"amt\">";
                            strTb += strTbList;
                            strTb += "<tr>";
                            strTb += "<th style='border-bottom:1px solid #000;'>소계</th>";
                            strTb += "<td style='border-bottom:1px solid #000;'>" + (intTotalSupplyAmt.Equals(0) ? "0" : intTotalSupplyAmt.ToString("##,###")) + "</td>";
                            strTb += "<td style='border-bottom:1px solid #000;'>" + (intTotalTaxAmt.Equals(0) ? "0" : intTotalTaxAmt.ToString("##,###")) + "</td>";
                            strTb += "</tr>";
                            strTb += strAdvanceTbList;
                            strTb += "<tr>";
                            strTb += "<th>총청구금액</th>";
                            strTb += "<td colspan='2'>" + (intTotalSupplyAmt + intTotalTaxAmt + intTotalAdvanceOrgAmt).ToString("##,###") + "</td>";
                            strTb += "</tr>";
                            strTb += "</tbody>";
                            strTb += "</table>";

                            //상세내역
                            strTb += "<h2>상세내역</h2>";
                            strTb += "<div " + objStyleW + ">";

                            strTb += "<table class=\"type_02\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:20px\"/>";
                            strTb += "<col style=\"width:20px\"/>";
                            strTb += "<col style=\"width:70px\"/>";
                            strTb += "<col style=\"width:110px\"/>";
                            strTb += "<col style=\"width:30px\"/>";
                            strTb += "<col style=\"width:30px\"/>";
                            strTb += "<col style=\"width:40px\"/>";
                            strTb += "<col style=\"width:70px\"/>";
                            strTb += "<col style=\"width:70px\"/>";
                            strTb += "<col style=\"width:55px\"/>";
                            strTb += "<col style=\"width:55px\"/>";
                            strTb += "<col style=\"width:48px\"/>";
                            strTb += "<col style=\"width:48px\"/>";
                            strTb += "<col style=\"width:48px\"/>";
                            strTb += "<col style=\"width:50px\"/>";
                            strTb += "</colgroup>";
                            strTb += "<thead>";
                            strTb += "<tr>";
                            strTb += "<th>No</th>";
                            strTb += "<th>작업일</th>";
                            strTb += "<th>상품</th>";
                            strTb += "<th>화주</th>";
                            strTb += "<th>수량</th>";
                            strTb += "<th>무게</th>";
                            strTb += "<th>품목</th>";
                            strTb += "<th>B/L <br> No</th>";
                            strTb += "<th>CNTR <br> No</th>";
                            strTb += "<th>SEAL <br> No</th>";
                            strTb += "<th>DOOR</th>";
                            strTb += "<th>부킹 No</th>";
                            strTb += "<th>운송료</th>";
                            strTb += "<th>대납금</th>";
                            strTb += "<th>담당자</th>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "<tbody>";
                        }

                        for (var i = 0; i < lo_objResOrderDispatchList.data.list.Count; i++)
                        {
                            if (i.Equals(lo_strDistinctIndex[f]))
                            {
                                double SupplyAmtTotal = 0;

                                for (var y = 0; y < lo_objResOrderDispatchList.data.list.Count; y++)
                                {
                                    if (lo_objResOrderDispatchList.data.list[y].OrderNo.Equals(lo_strDistinctOrderNo[f]))
                                    {
                                        //운임
                                        if (lo_objResOrderDispatchList.data.list[y].ItemCode.Equals("OP001"))
                                        {
                                            SupplyAmtTotal += lo_objResOrderDispatchList.data.list[y].SupplyAmt.ToDouble();
                                        }
                                    }

                                }
                                strTb += "<tr class=\"pd0\">";
                                strTb += "<td>" + (f + 1) + "</td>";
                                strTb += "<td>" + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[i].PickupYMD).Substring(5) + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].OrderItemCodeM + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].ConsignorName + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].Volume + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].Weight + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].GoodsItemCodeM + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].BLNo + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].CntrNo + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].SealNo + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].PickupPlaceLocalName + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].BookingNo + "</td>";
                                strTb += "<td>" + SupplyAmtTotal.ToString("##,###") + "</td>";
                                strTb += $"<td>{lo_objResOrderDispatchList.data.list[i].AdvanceOrgAmt.ToDouble():#,##0}</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].PayClientChargeName + "</td>";
                                strTb += "</tr>";
                            }
                        }
                    }
                    strTb += "</tbody>";
                    strTb += "</table>";
                    strTb += "</div>";
                    strTb += "</div>";

                }

                repDetailList.Text = strTb;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("OrderInoutPrintClient", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9305);
            }
        }
    }
}