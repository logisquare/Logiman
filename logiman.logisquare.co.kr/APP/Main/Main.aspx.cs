using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using PBSDasNetCom;
using System;

namespace APP
{
    public partial class Main : AppPageBase
    {
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
                AdminName.Text = objSes.AdminName;
                CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Main", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9300);
            }
        }
    }
}