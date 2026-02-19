using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderContainerPrintClient : PageBase
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
            PageNo.Value   = "1";

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
            HidGridID.Value        = SiteGlobal.GetRequestForm("GridID");
            CenterCode.Value       = SiteGlobal.GetRequestForm("CenterCode");
            ClientCode.Value       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "");
            PdfFlag.Value          = Utils.IsNull(SiteGlobal.GetRequestForm("PdfFlag"),    "N");
            SendMail.Text          = objSes.Email;
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
            ReqClientChargeList                lo_objReqClientChargeList = null;
            ServiceResult<ResClientChargeList> lo_objResClientChargeList = null;
            ClientDasServices                  objClientDasServices      = new ClientDasServices();

            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("청구담당자", ""));

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
                SiteGlobal.WriteLog("OrderContainerPrintClient", "Exception",
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
                SiteGlobal.WriteLog("OrderContainerPrintClient", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9304);
            }
        }

        protected void GetPrintList(ServiceResult<ResOrderDispatchAdvanceList> lo_objResOrderDispatchAdvanceList)
        {
            ReqOrderDispatchList                lo_objReqOrderDispatchList = null;
            ServiceResult<ResOrderDispatchList> lo_objResOrderDispatchList = null;
            int                                 lo_intListType             = 1;
            string                              strTb                      = string.Empty;
            double                              intSupplyAmtTotal          = 0;
            double                              intTaxAmtTotal             = 0;

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
                    MailTitle.Value = "운송내역서(건)_(" + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[0].PickupYMD) + " ~ " + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[lo_objResOrderDispatchList.data.list.Count - 1].PickupYMD) + ")";

                    ClientName.Value     = lo_objResOrderDispatchList.data.list[0].PayClientName;
                    CenterName.Value     = lo_objResOrderDispatchList.data.list[0].CenterName;
                    SupplyAmtTotal.Value = lo_objResOrderDispatchList.data.SupplyAmtTotal.ToString();
                    TaxAmtTotal.Value    = lo_objResOrderDispatchList.data.TaxAmtTotal.ToString();
                    OrgAmtTotal.Value    = lo_objResOrderDispatchList.data.OrgAmtTotal.ToString();

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

                    for (var j = 0; j < lo_strDistinctIndex.Count; j++)
                    {
                        for (var i = 0; i < lo_objResOrderDispatchList.data.list.Count; i++)
                        {
                            if (i.Equals(lo_strDistinctIndex[j]))
                            {
                                double TotalAdvanceOrgAmt = 0;

                                intSupplyAmtTotal =  0;
                                intTaxAmtTotal    =  0;
                                strTb             += "<div class=\"page_line\">";

                                if (i.Equals(0))
                                {
                                    strTb += "<ul class=\"top_ul first\">";
                                }
                                else
                                {
                                    strTb += "<ul class=\"top_ul\">";
                                }

                                strTb += "<li>" + lo_objResOrderDispatchList.data.list[i].CenterName + "</li>";
                                strTb += "<li>출력일 : " + DateTime.Now.ToString("yyyy-MM-dd") + "</li>";
                                strTb += "</ul>";
                                strTb += "<h1>운송내역서(건)_(" + Utils.ConvertDateFormat(lo_objResOrderDispatchList.data.list[i].PickupYMD) + ") - " + lo_objResOrderDispatchList.data.list[i].OrderItemCodeM + "</h1>";
                                strTb += "<table class=\"type_01\">";
                                strTb += "<colgroup>";
                                strTb += "<col style=\"width:280px\"/>";
                                strTb += "<col style=\"width:220px\"/>";
                                strTb += "<col style=\"width:220px\"/>";
                                strTb += "<thead>";
                                strTb += "<tr>";
                                strTb += "<th>고객사</th>";
                                strTb += "<th>담당자</th>";
                                strTb += "<th>화주명</th>";
                                strTb += "</tr>";
                                strTb += "</thead>";
                                strTb += "<tbody>";
                                strTb += "<tr>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].ClientName + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].PayClientChargeName + "</td>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].ConsignorName + "</td>";
                                strTb += "</tr>";
                                strTb += "</tbody>";
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
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].CenterNameInfo + "</td>";
                                strTb += "<th>대표번호/팩스</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].TelNoInfo + " / " + lo_objResOrderDispatchList.data.list[i].FaxNoInfo + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>주소</th>";
                                strTb += "<td colspan=\"3\">";
                                strTb += lo_objResOrderDispatchList.data.list[i].AddrInfo + "(우편번호 " + lo_objResOrderDispatchList.data.list[i].AddrPostInfo + ")";
                                strTb += "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>계좌정보</th>";
                                strTb += "<td colspan=\"3\">";
                                strTb += "예금주 : " + lo_objResOrderDispatchList.data.list[i].AcctNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;은행명 : " + lo_objResOrderDispatchList.data.list[i].BankNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;계좌번호 : " + lo_objResOrderDispatchList.data.list[i].AcctNo;
                                strTb += "</td>";
                                strTb += "</tr>";
                                strTb += "</thead>";
                                strTb += "</table>";

                                //운송정보
                                strTb += "<h2>운송정보</h2>";
                                strTb += "<table class=\"type_02\">";
                                strTb += "<colgroup>";
                                strTb += "<col style=\"width:100px;\"/>";
                                strTb += "<col style=\"width:auto;\"/>";
                                strTb += "<col style=\"width:100px;\"/>";
                                strTb += "<col style=\"width:auto;\"/>";
                                strTb += "</colgroup>";
                                strTb += "<tbody>";
                                strTb += "<tr>";
                                strTb += "<th>오더정보</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].OrderNo + "</td>";
                                strTb += "<th>작업일</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].PickupYMD + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>작업지</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].PickupPlace + "</td>";
                                strTb += "<th>하차CY</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].GetCY + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>품목</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].GoodsItemCodeM + "</td>";
                                strTb += "<th>B/L No</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].BLNo + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>선사</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].ShippingCompany + "</td>";
                                strTb += "<th>선명</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].ShippingShipName + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>CNTR NO</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].CntrNo + "</td>";
                                strTb += "<th>SEAL NO</th>";
                                strTb += "<td>" + lo_objResOrderDispatchList.data.list[i].SealNo + "</td>";
                                strTb += "</tr>";
                                strTb += "<tr>";
                                strTb += "<th>B.K NO</th>";
                                strTb += "<td colspan='3'>" + lo_objResOrderDispatchList.data.list[i].BookingNo + "</td>";
                                strTb += "</tr>";
                                strTb += "</tbody>";
                                strTb += "</table>";

                                //청구내역
                                strTb += "<h2>청구내역</h2>";
                                strTb += "<div class=\"list_tb\">";
                                strTb += "<table class=\"type_02\">";
                                strTb += "<colgroup>";
                                strTb += "<col style=\"width:100px\"/>";
                                strTb += "<col style=\"width:310px\"/>";
                                strTb += "<col style=\"width:310px\"/>";
                                strTb += "</colgroup>";
                                strTb += "<thead>";
                                strTb += "<tr>";
                                strTb += "<th>항목</th>";
                                strTb += "<th>공급가액(원)</th>";
                                strTb += "<th>부가세(원)</th>";
                                strTb += "</tr>";
                                strTb += "</thead>";
                                strTb += "<tbody class=\"amt\">";

                                for (var v = 0; v < lo_objResOrderDispatchList.data.list.Count; v++)
                                {
                                    if (lo_objResOrderDispatchList.data.list[v].OrderNo.Equals(lo_strDistinctOrderNo[j]))
                                    {
                                        intSupplyAmtTotal += lo_objResOrderDispatchList.data.list[v].SupplyAmt.ToDouble();
                                        intTaxAmtTotal += lo_objResOrderDispatchList.data.list[v].TaxAmt.ToDouble();

                                        strTb += "<tr>";
                                        strTb += "<th>" + lo_objResOrderDispatchList.data.list[v].ItemCodeM + "</th>";
                                        strTb += "<td>" + (lo_objResOrderDispatchList.data.list[v].SupplyAmt.Equals("0") ? "0" : $"{lo_objResOrderDispatchList.data.list[v].SupplyAmt.ToDouble():#,###}") + "</td>";
                                        strTb += "<td>" + (lo_objResOrderDispatchList.data.list[v].TaxAmt.Equals("0") ? "0" : $"{lo_objResOrderDispatchList.data.list[v].TaxAmt.ToDouble():#,###}") + "</td>";
                                        strTb += "</tr>";
                                    }
                                }

                                strTb += "<tr>";
                                strTb += "<th style='border-bottom:1px solid #000;'>소계</th>";
                                strTb += "<td style='border-bottom:1px solid #000;'>" + (intSupplyAmtTotal.Equals(0) ? "0" : intSupplyAmtTotal.ToString("##,###")) + "</td>";
                                strTb += "<td style='border-bottom:1px solid #000;'>" + (intTaxAmtTotal.Equals(0) ? "0" : intTaxAmtTotal.ToString("##,###")) + "</td>";
                                strTb += "</tr>";

                                if (lo_objResOrderDispatchAdvanceList != null)
                                {
                                    for (var iFor = 0; iFor < lo_objResOrderDispatchAdvanceList.data.RecordCnt; iFor++)
                                    {
                                        if (lo_objResOrderDispatchAdvanceList.data.list[iFor].OrderNo.Equals(lo_strDistinctOrderNo[j]))
                                        {
                                            TotalAdvanceOrgAmt += lo_objResOrderDispatchAdvanceList.data.list[iFor].OrgAmt.ToDouble();
                                            strTb += "<tr>";
                                            strTb += $"<th>대납금({lo_objResOrderDispatchAdvanceList.data.list[iFor].ItemCodeM})</th>";
                                            strTb += $"<td>{lo_objResOrderDispatchAdvanceList.data.list[iFor].SupplyAmt.ToDouble():#,##0}</td>";
                                            strTb += $"<td>{lo_objResOrderDispatchAdvanceList.data.list[iFor].TaxAmt.ToDouble():#,##0}</td>";
                                            strTb += "</tr>";
                                        }
                                    }
                                }

                                strTb += "<tr>";
                                strTb += "<th>총 청구금액</th>";
                                strTb += "<td colspan='2'>" + ((intSupplyAmtTotal + intTaxAmtTotal + TotalAdvanceOrgAmt).Equals(0) ? "0" : (intSupplyAmtTotal + intTaxAmtTotal + TotalAdvanceOrgAmt).ToString("##,###")) + "</td>";
                                strTb += "</tr>";
                                strTb += "</tbody>";
                                strTb += "</table>";
                                strTb += "</tbody>";
                                strTb += "</table>";
                                strTb += "<p class=\"charge_info\">" + (lo_objResOrderDispatchList.data.list[i].OrderLocationCodeM != "" ? "[" + lo_objResOrderDispatchList.data.list[i].OrderLocationCodeM + "]" : "") + "접수자 : " + lo_objResOrderDispatchList.data.list[i].AcceptAdminName + "</p>";
                                strTb += "</div>";
                                strTb += "</div>";

                                if (j != lo_strDistinctOrderNo.Count - 1)
                                {
                                    strTb += "<div style=\"page-break-before:always;\"></div>";
                                }
                            }
                        }
                    }
                }

                repDetailList.Text = strTb;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("OrderContainerPrintClient", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9305);
            }
        }
    }
}