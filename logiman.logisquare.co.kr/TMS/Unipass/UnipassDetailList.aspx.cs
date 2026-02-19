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
    public partial class UnipassDetailList : PageBase
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
                PageNo.Value    = "1";
                PageSize.Value  = CommonConstant.GRID_PAGENAVIGATION_LIST;
                HidMode.Value   = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
                Hawb.Value      = Utils.IsNull(SiteGlobal.GetRequestForm("Hawb"), "");
                BLNo.Value      = Utils.IsNull(SiteGlobal.GetRequestForm("BLNo"), "");
                PickupYMD.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PickupYMD"), "");
                CHART_YEAR_DDLB(SearchYear); //년도 가져오기
                SearchType.Items.Clear();
                SearchType.Items.Add(new ListItem("검색어", ""));
                SearchType.Items.Add(new ListItem("화물관리번호", "cargMtNo"));
                SearchType.Items.Add(new ListItem("M B/L", "MBL"));
                SearchType.Items.Add(new ListItem("H B/L", "HBL"));
                
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("UnipassDetailList", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9501);
            }
        }

        public static void CHART_YEAR_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            int currYear  = DateTime.Now.Year;
            int currNextYear  = DateTime.Now.Year + 1;
            int startYear = currYear - 8;

            DDLB.Items.Add(new ListItem(currNextYear.ToString(), currNextYear.ToString()));
            for (int i = currYear; i >= startYear; i--)
            {
                DDLB.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
            
            DDLB.SelectedValue = currYear.ToString();
        }
    }
}