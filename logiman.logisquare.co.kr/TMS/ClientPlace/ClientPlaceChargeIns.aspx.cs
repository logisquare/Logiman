using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Data;
using PBSDasNetCom;
using CommonLibrary.DasServices;
using CommonLibrary.CommonModel;
using CommonLibrary.Extensions;
using CommonLibrary.Constants;

namespace TMS.ClientPlace
{
    public partial class ClientPlaceChargeIns : PageBase
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
                HidMode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
                PlaceSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "");
                PageNo.Value = "1";
                PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
                CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

                if (HidMode.Value.Equals("Update")) {
                    ChargeNote.Attributes.Add("style", "width:700px");
                    AddChargeBtn.Visible = true;
                    ResetChargeBtn.Visible = true;
                    GridClientCharge.Visible = true;
                    UseFlagArea.Visible = true;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("ClientPlaceChargeIns", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9501);
            }
        }
    }
}