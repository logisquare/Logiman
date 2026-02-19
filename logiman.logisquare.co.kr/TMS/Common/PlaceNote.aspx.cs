using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Common
{
    public partial class PlaceNote : PageBase
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
            string lo_strCenterCode   = string.Empty;
            string lo_strOrderType    = string.Empty;
            string lo_strPlaceType    = string.Empty;
            string lo_strPlaceName    = string.Empty;
            string lo_strPlaceAddr    = string.Empty;
            string lo_strPlaceAddrDtl = string.Empty;

            lo_strCenterCode   = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),   string.Empty);
            lo_strOrderType    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"),    string.Empty);
            lo_strPlaceType    = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceType"),    string.Empty);
            lo_strPlaceName    = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceName"),    string.Empty);
            lo_strPlaceAddr    = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceAddr"),    string.Empty);
            lo_strPlaceAddrDtl = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceAddrDtl"), string.Empty);


            CenterCode.Value    = lo_strCenterCode;
            OrderType.Value     = lo_strOrderType;
            PlaceType.Value     = lo_strPlaceType;
            PlaceName.Value     = lo_strPlaceName;
            PlaceAddr.Value     = lo_strPlaceAddr;
            PlaceAddrDtl.Value  = lo_strPlaceAddrDtl;


            NoteTitle.InnerText = "상하차지 특이사항";

            switch (lo_strOrderType)
            {
                case "1":
                    H3Name.InnerText    = "내수";
                    DivDomestic.Visible = true;
                    break;
                case "2":
                    H3Name.InnerText = "수출입";
                    DivInout.Visible = true;
                    break;
                case "3":
                    H3Name.InnerText     = "컨테이너";
                    NoteTitle.InnerText  = "작업지 특이사항";
                    DivContainer.Visible = true;
                    break;
            }
        }
    }
}