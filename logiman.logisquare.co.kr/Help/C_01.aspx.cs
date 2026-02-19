using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;

namespace Help
{
    public partial class C_01 : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
            IgnoreCheckMenuAuth();
        }
    }
}