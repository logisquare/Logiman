using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace WEB.Manage
{
    public partial class WebOrderPlaceIns : PageBase
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
            try
            {
                HidMode.Value    = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"),    "");
                PlaceSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "");
                PageNo.Value     = "1";
                PageSize.Value   = CommonConstant.GRID_PAGENAVIGATION_LIST;

                CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

                if (HidMode.Value.Equals("Update")) {
                    ChargeNote.Attributes.Add("style", "width:700px");
                    AddChargeBtn.Visible     = true;
                    ResetChargeBtn.Visible   = true;
                    GridClientCharge.Visible = true;
                    BtnPostSearch.Visible    = false;
                    UseFlagArea.Visible      = true;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("WebOrderPlaceIns", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9501);
            }
        }
    }
}