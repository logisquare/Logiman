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

namespace TMS.Unipass
{
    public partial class UnipassContainerList : PageBase
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
                cargMtNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("cargMtNo"), "");
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("UnipassContainerList", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9501);
            }
        }
    }
}