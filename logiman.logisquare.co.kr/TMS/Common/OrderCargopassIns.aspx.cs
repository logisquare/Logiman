using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderCargopassIns : PageBase
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
            string lo_strDispatchType     = string.Empty;
            string lo_strCenterCode       = string.Empty;
            string lo_strOrderNos         = string.Empty;
            string lo_strCargopassOrderNo = string.Empty;
            string lo_strInsCallback      = string.Empty;

            lo_strDispatchType     = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchType"),     string.Empty);
            lo_strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),       string.Empty);
            lo_strOrderNos         = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNos"),         string.Empty);
            lo_strCargopassOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("CargopassOrderNo"), string.Empty);
            lo_strInsCallback      = Utils.IsNull(SiteGlobal.GetRequestForm("InsCallback"),      string.Empty);

            OrderNos.Value = lo_strOrderNos;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            DispatchType.Items.Clear();
            DispatchType.Items.Add(new ListItem("배차구분", ""));
            DispatchType.Items.Add(new ListItem("직송",   "1"));
            DispatchType.Items.Add(new ListItem("집하",   "2"));
            DispatchType.Items.Add(new ListItem("간선",   "3"));

            CommonDDLB.PICKUP_WAY_DDLB(PickupWay);
            PickupWay.SelectedIndex = 1;
            CommonDDLB.GET_WAY_DDLB(GetWay);
            GetWay.SelectedIndex = 1;

            //CommonDDLB.CARGOPASS_CARTON_DDLB(CarTon);
            //CommonDDLB.CARGOPASS_CARTRUCK_DDLB(CarTruck);

            CommonDDLB.ITEM_NAME_DDLB(Page, CarTon, "CB", objSes.AccessCenterCode, objSes.AdminID, "톤수");
            CommonDDLB.ITEM_NAME_DDLB(Page, CarTruck, "CA", objSes.AccessCenterCode, objSes.AdminID, "차종");

            if (!string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                CenterCode.SelectedValue = CenterCode.Items.FindByValue(lo_strCenterCode) != null ? lo_strCenterCode : string.Empty;
            }

            if (!string.IsNullOrWhiteSpace(lo_strDispatchType))
            {
                DispatchType.SelectedValue = DispatchType.Items.FindByValue(lo_strDispatchType) != null ? lo_strDispatchType : string.Empty;
            }

            CargopassDomain.Value = SiteGlobal.CARGOPASS_DOMAIN;

            if (!string.IsNullOrWhiteSpace(lo_strCargopassOrderNo))
            {
                HidMode.Value            = "Update";
                CargopassOrderNo.Text    = lo_strCargopassOrderNo;
                CargopassOrderNo.Attributes.Remove("style");
            }
            else
            {
                HidMode.Value            = "Insert";
                InsCallback.Value        = lo_strInsCallback;
                TelNo.Text               = objSes.TelNo;
                CargopassOrderNo.Attributes.Add("style", "display:none");

                if (string.IsNullOrWhiteSpace(objSes.Network24DDID) && string.IsNullOrWhiteSpace(objSes.NetworkHMMID) && string.IsNullOrWhiteSpace(objSes.NetworkOneCallID) && string.IsNullOrWhiteSpace(objSes.NetworkHmadangID))
                {
                    HidDisplayMode.Value = "Y";
                    HidErrMsg.Value      = "내 정보 수정에서 각 정보망의 아이디를 입력해야 연동이 가능합니다.";
                }
            }
        }
    }
}