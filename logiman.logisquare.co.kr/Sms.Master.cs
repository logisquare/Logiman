using CommonLibrary.Constants;
using System;
using System.Web.UI;

namespace logiman.logisquare.co.kr
{
    public partial class SmsMaster : MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            Page.Title = CommonConstant.SMS_TITLE;
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
        }
    }
}