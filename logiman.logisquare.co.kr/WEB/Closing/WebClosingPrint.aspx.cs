using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace WEB.Closing
{
    public partial class WebClosingPrint : PageBase
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
        }

        protected void GetInitData()
        {
            string lo_strSaleClosingSeqNo = string.Empty;
            string lo_strCenterCode       = string.Empty;

            lo_strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            lo_strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("HidCenterCode"), "0");
            StartYMD.Text          = Utils.IsNull(Utils.ConvertDateFormat(SiteGlobal.GetRequestForm("StartYMD")), "");
            EndYMD.Text            = Utils.IsNull(Utils.ConvertDateFormat(SiteGlobal.GetRequestForm("EndYMD")), "");

            if (string.IsNullOrWhiteSpace(lo_strCenterCode) || lo_strCenterCode.Equals("0"))
            {
                DisplayMode.Value = "Y";
                ErrMsg.Value = "필요한 정보가 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(lo_strSaleClosingSeqNo) || lo_strSaleClosingSeqNo.Equals("0"))
            {
                DisplayMode.Value = "Y";
                ErrMsg.Value = "필요한 정보가 없습니다.";
                return;
            }

            GetOrderSaleDetail(lo_strSaleClosingSeqNo, lo_strCenterCode);
        }

        protected void GetOrderSaleDetail(string lo_strSaleClosingSeqNo, string lo_strCenterCode)
        {
            string                                 lo_strAmtList                 = string.Empty;
            Double                                 lo_intTotalSupplyAmt          = 0;
            Double                                 lo_intTotalTaxAmt             = 0;
            ReqOrderSaleClosingList                lo_objReqOrderSaleClosingList = null;
            ServiceResult<ResOrderSaleClosingList> lo_objResOrderSaleClosingList = null;
            WebOrderDasServices                    objWebOrderDasServices        = new WebOrderDasServices();

            try
            {
                lo_objReqOrderSaleClosingList = new ReqOrderSaleClosingList
                {
                    SaleClosingSeqNo = lo_strSaleClosingSeqNo.ToInt64(),
                    CenterCode       = lo_strCenterCode.ToInt(),
                    GradeCode        = objSes.GradeCode,
                    AccessCenterCode = objSes.AccessCenterCode,
                    AccessCorpNo     = objSes.AccessCorpNo
                };

                lo_objResOrderSaleClosingList = objWebOrderDasServices.GetOrderSaleClosingClientDtlList(lo_objReqOrderSaleClosingList);

                if (lo_objResOrderSaleClosingList.result.ErrorCode.IsFail() || lo_objResOrderSaleClosingList.data.list.Count.Equals(0))
                {
                    DisplayMode.Value = "Y";
                    ErrMsg.Value      = "정보를 조회하지 못했습니다.";
                    return;
                }

                ClientName.Text     = lo_objResOrderSaleClosingList.data.list[0].ClientName;
                ClientCeoName.Text  = lo_objResOrderSaleClosingList.data.list[0].ClientCeoName;
                ClientCorpNo.Text   = lo_objResOrderSaleClosingList.data.list[0].ClientCorpNo;
                AcctName.Text       = lo_objResOrderSaleClosingList.data.list[0].AcctName; 
                BankName.Text       = lo_objResOrderSaleClosingList.data.list[0].BankName;
                EncAcctNo.Text      = Utils.GetDecrypt(lo_objResOrderSaleClosingList.data.list[0].EncAcctNo);
                CenterName.Text     = lo_objResOrderSaleClosingList.data.list[0].CenterName;
                Addr.Text           = lo_objResOrderSaleClosingList.data.list[0].Addr;
                TelNo.Text          = lo_objResOrderSaleClosingList.data.list[0].TelNo;
                FaxNo.Text          = lo_objResOrderSaleClosingList.data.list[0].FaxNo;
                //운임구분
                
                foreach (OrderSaleClosingListGrid lo_objSaleClosing in lo_objResOrderSaleClosingList.data.list)
                {
                    lo_strAmtList        += "<tr>";
                    lo_strAmtList        += $"<th>{lo_objSaleClosing.SaleItemCodeM}</th>";
                    lo_strAmtList        += $"<td>{lo_objSaleClosing.SupplyAmt.ToDouble():n0}</td>";
                    lo_strAmtList        += $"<td>{lo_objSaleClosing.TaxAmt.ToDouble():n0}</td>";
                    lo_strAmtList        += "</tr>";
                    lo_intTotalSupplyAmt += lo_objSaleClosing.SupplyAmt.ToDouble();
                    lo_intTotalTaxAmt    += lo_objSaleClosing.TaxAmt.ToDouble();
                }
                
                AmtList.InnerHtml = lo_strAmtList;
                //소계
                TotalSupplyAmt.InnerText = $"{lo_intTotalSupplyAmt:n0}";
                TotalTaxAmt.InnerText    = $"{lo_intTotalTaxAmt:n0}";
                //대납금
                AdvanceOrgAmt.InnerText = $"{lo_objResOrderSaleClosingList.data.AdvanceOrgAmt:n0}";
                TotalAmt.InnerHtml      = $"{lo_intTotalSupplyAmt + lo_intTotalTaxAmt + lo_objResOrderSaleClosingList.data.AdvanceOrgAmt:n0}";
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("WebClosingPrint", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9101);
            }
        }
    }
}