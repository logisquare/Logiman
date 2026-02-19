using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderCopy : PageBase
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
            string lo_strOrderType  = string.Empty;
            string lo_strCenterCode = string.Empty;
            string lo_strOrderNos   = string.Empty;
;
            lo_strOrderType  = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"),  "");
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            lo_strOrderNos   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos"),   "");

            OrderType.Value  = lo_strOrderType;
            CenterCode.Value = lo_strCenterCode;
            OrderNos.Value   = lo_strOrderNos;

            if (string.IsNullOrWhiteSpace(lo_strOrderType) || string.IsNullOrWhiteSpace(lo_strCenterCode) || string.IsNullOrWhiteSpace(lo_strOrderNos))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
                return;
            }

            OrderCnt.Items.Clear();

            if (lo_strOrderNos.IndexOf(",", StringComparison.Ordinal) > -1)
            {
                OrderCnt.Items.Add(new ListItem("1", "1"));
            }
            else
            {
                for (int i = 1; i <= 50; i++)
                {
                    OrderCnt.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
            }

            GetYMDType.Items.Clear();
            GetYMDType.Items.Add(new ListItem("하차일 선택", ""));
            GetYMDType.Items.Add(new ListItem("당착",     "1"));
            GetYMDType.Items.Add(new ListItem("익착",     "2"));
            GetYMDType.SelectedIndex = 1;

            switch (lo_strOrderType)
            {
                case "1": //내수
                    SpanGoodsFlag.Visible      = true;
                    SpanNoteFlag.Visible       = true;
                    SpanNoteClientFlag.Visible = true;
                    SpanDispatchFlag.Visible   = true;
                    SpanHelp.InnerText         = " (* 집하/간선 오더는 배차가 복사되지 않습니다.)";
                    break;
                case "2": //수출입
                    SpanGoodsFlag.Visible         = true;
                    SpanNoteClientFlag.Visible    = true;
                    SpanArrivalReportFlag.Visible = true;
                    SpanTaxChargeFlag.Visible     = true;
                    SpanCustomFlag.Visible        = true;
                    SpanBondedFlag.Visible        = true;
                    break;
                case "3": //컨테이너
                    SpanNoteClientFlag.Visible = true;
                    SpanGoodsFlag.Visible      = true;
                    SpanGetYMD.Visible         = false;
                    break;
            }
        }
    }
}