using CommonLibrary.CommonModule;
using System;
using System.Web.UI;

namespace SMS
{
    public partial class Terms : PageInit
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
        }
    }
}