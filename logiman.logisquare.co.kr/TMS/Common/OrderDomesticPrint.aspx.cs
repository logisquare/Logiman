using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using CommonLibrary.Extensions;

namespace TMS.Common
{
    public partial class OrderDomesticPrint : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
            else {
                GetPostBackData();
            }
        }

        protected void GetInitData()
        {
            string lo_strOrderNos1        = string.Empty;
            string lo_strOrderNos2        = string.Empty;
            string lo_strSaleClosingSeqNo = String.Empty;
            PageSize.Value  = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value    = "1";
            lo_strOrderNos1 = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos1"), "");
            lo_strOrderNos2 = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos2"), ""); 

            lo_strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            if(!lo_strSaleClosingSeqNo.Equals("0"))
            {
                SaleClosingChk.Visible = false;
            }
            OrderNos1.Value        = lo_strOrderNos1; 
            OrderNos2.Value        = lo_strOrderNos2;
            SaleClosingSeqNo.Value = lo_strSaleClosingSeqNo;

            CenterCode.Value    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0"); 
            ClientCode.Value    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            DateFrom.Value      = SiteGlobal.GetRequestForm("DateFrom");
            DateTo.Value        = SiteGlobal.GetRequestForm("DateTo");
            hidPage.Value       = HttpContext.Current.Request.Url.AbsoluteUri;
            PdfFlag.Value       = Utils.IsNull(SiteGlobal.GetRequestForm("PdfFlag"), "N");
            SendMail.Text       = objSes.Email;
            AdminName.Value     = objSes.AdminName;
            AdminID.Value       = objSes.AdminID;
            AdminTel.Value      = objSes.TelNo;
            AdminMobile.Value   = objSes.MobileNo;
            DeptName.Value      = objSes.DeptName;
            AdminPosition.Value = objSes.Position;
            AdminMail.Value     = objSes.Email;

            CLIENT_CHARGE_DDLB(ChargeNameList, CenterCode.Value, ClientCode.Value);
            if (PdfFlag.Value.Equals("Y"))
            {
                BtnArea.Visible = false;
            }

            DisplayData();
        }

        protected void GetPostBackData() {
            string lo_strEventTarget = SiteGlobal.GetRequestForm("__EVENTTARGET");
            try
            {
                
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("OrderPrintList", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9301);
            }
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
                    ClientCode   = lo_strClientCode.ToInt(),
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
                SiteGlobal.WriteLog("OrderPrintList", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9303);
            }
        }

        protected void DisplayData()
        {
            ReqOrderDispatchList                lo_objReqOrderList          = null;
            ServiceResult<ResOrderDispatchList> lo_objResOrderList          = null;
            OrderDispatchDasServices            objOrderDispatchDasServices = new OrderDispatchDasServices();

            int    lo_intListType = 1;
            string objStyleW      = string.Empty;
            string strTb          = string.Empty;

            try
            {
                lo_objReqOrderList = new ReqOrderDispatchList
                {
                    CenterCode = CenterCode.Value.ToInt(),
                    OrderNos1 = OrderNos1.Value,
                    OrderNos2 = OrderNos2.Value,
                    SaleClosingSeqNo = SaleClosingSeqNo.Value.ToInt64(),
                    ClientCode = ClientCode.Value.ToInt64(),
                    ListType = lo_intListType.ToInt()
                };

                lo_objResOrderList = objOrderDispatchDasServices.GetOrderDispatchDomesticPrintList(lo_objReqOrderList);

                if (lo_objResOrderList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value      = "정보를 조회하지 못했습니다.";
                    return;
                }

                if (lo_objResOrderList.data.RecordCnt > 0)
                {
                    ClientName.Value = lo_objResOrderList.data.list[0].PayClientName;
                    CenterName.Value = lo_objResOrderList.data.list[0].CenterName;

                    for (var f = 0; f < lo_objResOrderList.data.RecordCnt; f++)
                    {
                        if (f.Equals(0))
                        {
                            SupplyAmtTotal.Value = lo_objResOrderList.data.SupplyAmtTotal.ToString();
                            TaxAmtTotal.Value    = lo_objResOrderList.data.TaxAmtTotal.ToString();
                            OrgAmtTotal.Value = lo_objResOrderList.data.OrgAmtTotal.ToString();

                            strTb += "<div class=\"page_line\">";
                            strTb += "<ul class=\"top_ul\">";
                            strTb += "<li>" + lo_objResOrderList.data.list[0].CenterNameInfo + "</li>";
                            strTb += "<li>출력일 : " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "</li>";
                            strTb += "</ul>";
                            strTb += "<h1 id=\"MailTitle\">거래명세서(" + Utils.ConvertDateFormat(lo_objResOrderList.data.list[0].PickupYMD) + " ~ " + Utils.ConvertDateFormat(lo_objResOrderList.data.list[lo_objResOrderList.data.RecordCnt - 1].PickupYMD) + ")</h1>";

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
                            strTb += "<td>" + lo_objResOrderList.data.list[f].CenterNameInfo + "</td>";
                            strTb += "<th>대표번호/팩스</th>";
                            strTb += "<td>" + lo_objResOrderList.data.list[f].TelNoInfo + " / " + lo_objResOrderList.data.list[f].FaxNoInfo + "</td>";
                            strTb += "</tr>";
                            strTb += "<tr>";
                            strTb += "<th>주소</th>";
                            strTb += "<td colspan=\"3\">";
                            strTb += lo_objResOrderList.data.list[f].AddrInfo + "(우편번호 " + lo_objResOrderList.data.list[f].AddrPostInfo + ")";
                            strTb += "</td>";
                            strTb += "</tr>";
                            strTb += "<tr>";
                            strTb += "<th>계좌정보</th>";
                            strTb += "<td colspan=\"3\">";
                            strTb += "예금주 : " + lo_objResOrderList.data.list[f].AcctNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;은행명 : " + lo_objResOrderList.data.list[f].BankNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;계좌번호 : " + lo_objResOrderList.data.list[f].AcctNo;
                            strTb += "</td>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "</table>";

                            strTb += "<h2>요약정보</h2>";
                            strTb += "<table class=\"type_01\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:25%\"/>";
                            strTb += "<col style=\"width:25%\"/>";
                            strTb += "<col style=\"width:25%\"/>";
                            strTb += "<col style=\"width:25%\"/>";
                            strTb += "<thead>";
                            strTb += "<tr>";
                            strTb += "<th>총 운송건수</th>";
                            strTb += "<th>공급가액</th>";
                            strTb += "<th>부가세</th>";
                            strTb += "<th>운송료합계</th>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "<tbody>";
                            strTb += "<tr>";
                            strTb += "<td>" + lo_objResOrderList.data.RecordCnt + "건</td>";
                            strTb += "<td>" + lo_objResOrderList.data.SupplyAmtTotal.ToString("##,###") + "</td>";
                            strTb += "<td>" + lo_objResOrderList.data.TaxAmtTotal.ToString("##,###") + "</td>";
                            strTb += "<td>" + lo_objResOrderList.data.OrgAmtTotal.ToString("##,###") + "</td>";
                            strTb += "</tr>";
                            strTb += "</tbody>";
                            strTb += "</table>";

                            //상세내역
                            strTb += "<h2>상세내역</h2>";
                            strTb += "<div " + objStyleW + ">";

                            strTb += "<table class=\"type_02\">";
                            strTb += "<colgroup>";
                            strTb += "<col style=\"width:40px\"/>";
                            strTb += "<col style=\"width:80px\"/>";
                            strTb += "<col style=\"width:auto;\"/>";
                            strTb += "<col style=\"width:auto;\"/>";
                            strTb += "<col style=\"width:100px\"/>";
                            strTb += "<col style=\"width:100px\"/>";
                            strTb += "<col style=\"width:80px\"/>";
                            strTb += "<col style=\"width:80px\"/>";
                            strTb += "</colgroup>";
                            strTb += "<thead>";
                            strTb += "<tr>";
                            strTb += "<th>No</th>";
                            strTb += "<th>운송일</th>";
                            strTb += "<th>상차지</th>";
                            strTb += "<th>하차지</th>";
                            strTb += "<th>차량번호</th>";
                            strTb += "<th>화물명</th>";
                            strTb += "<th>차량톤수</th>";
                            strTb += "<th>운송료</th>";
                            strTb += "</tr>";
                            strTb += "</thead>";
                            strTb += "<tbody>";
                        }

                        strTb += "<tr>";
                        strTb += "<td>" + (f + 1) + "</td>";
                        strTb += "<td>" + Utils.ConvertDateFormat(lo_objResOrderList.data.list[f].PickupYMD) + "</td>";
                        strTb += "<td>" + lo_objResOrderList.data.list[f].PickupPlace + "</td>";
                        strTb += "<td>" + lo_objResOrderList.data.list[f].GetPlace + "</td>";
                        strTb += "<td>" + lo_objResOrderList.data.list[f].CarNo + "</td>";
                        strTb += "<td>" + lo_objResOrderList.data.list[f].GoodsName + "</td>";
                        strTb += "<td>" + lo_objResOrderList.data.list[f].CarTonCodeM + "</td>";
                        strTb += "<td>" + $"{lo_objResOrderList.data.list[f].SupplyAmt.ToInt():#,###}" + "</td>";
                        strTb += "</tr>";
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
                SiteGlobal.WriteLog("OrderPrintList", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9304);
            }
        }
    }
}